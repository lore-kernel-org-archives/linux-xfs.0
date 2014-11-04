Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B8347F4E
	for <xfs@OSS.SGI.com>; Mon,  3 Nov 2014 18:06:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D126E8F8035
	for <xfs@OSS.SGI.com>; Mon,  3 Nov 2014 16:06:23 -0800 (PST)
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	z9Gc0FuVgYGDDisM for <xfs@OSS.SGI.com>;
	Mon, 03 Nov 2014 16:06:21 -0800 (PST)
Received: from ty.sabi.co.UK (94.192.123.208) by honeysuckle.london.02.net
	(8.5.140)
	id 53BD70B603E0D55B for xfs@OSS.SGI.com; Tue, 4 Nov 2014 00:32:49 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1XlRdB-0007jL-KN
	for <xfs@OSS.SGI.com>; Tue, 04 Nov 2014 00:05:53 +0000
MIME-Version: 1.0
Message-ID: <21592.6241.228215.412783@tree.ty.sabi.co.uk>
Date: Tue, 4 Nov 2014 00:05:53 +0000
Subject: Re: clone of filesystem across network preserving ionodes
In-Reply-To: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>
References: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>
From: pg@xfs.list.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@OSS.SGI.com>

> What is the best practice way to get the contents from
> server1 to server2 identical disk array partitions

Here you do not say that =ABget the contents=BB has to be over the
network, but the 'Subject:' line seems to indicate that.

> and preserve the ionode information using xfs tools or non-xfs
> tools? xfsdump/xfsrestore appear to not preserve this or I can
> not find the obvious setting.

If =ABpreserve the ionode information=BB means "keep the same
inumbers for each inode" that seems to me fairly pointless in
almost every situation (except perhaps for forensic purposes, and
that opens a whole series of other issues), so there is no =ABbest
practice way=BB as there is little or no practice, and management
speak won't change that. More clarity in explaining what you mean
and/or what you want to achieve would be better.

If you want for whatever reason to make a byte-by-byte copy from
block device X (potentially mounted on M) on host S1 to the
corresponding one of =ABidentical disk array partitions=BB Y on host
S2, which also preserves the inumbers, something fairly common is
to use 'ssh' as a network pipe (run on host S1):

  M=3D"`grep \"^$X\" /proc/mounts | cut -d' ' -f2`"
  case "$M" in ?*) xfs_freeze -f `"$M";; esac

  sudo sh -c "lzop < '$X'" | dd bs=3D64k iflag=3Dfullblock \
    | ssh -oCipher=3Darcfour -oCompression=3Dno "$S2" \
        "dd bs=3D64k iflag=3Dfullblock | sudo sh -c "\'"lzop -d > '$Y'"\'""

  case "$M" in ?*) xfs_freeze -u `"$M";; esac

If 'xfs_freeze' is suitable, and if no interruptions happen; if
they happen put reasonable "seek" and "skip" parameters on 'dd'
and rerun.

If the target block device is bigger than the source block
device, one can use 'xfs_growfs' after the byte-by-byte copy
(growing filetrees has downsides though).  Unless by =ABpreserve
the ionode information=BB or =ABidentical disk array partitions=BB you
mean something different from what they appear to mean to me.

The above just copied for me a 88GiB block device in 1624s
between two ordinary home PCs.

One could replace 'ssh' with 'nc' or similar network piping
commands for higher speed (at some cost). I also tried to
interpolate 'xfs_copy -d -b "$X" /dev/stdout | lzop ...'  but
'xfs_copy' won't do that, not entirely unexpectedly.

If by =ABpreserve the ionode information=BB you simply mean copy all
file attributes but without keeping the inumber (except for
'atime', but is usually disabled anyhow, and there is a patch to
restore it), if the source filetree is mounted at M on S1 and the
target is mounted at N (you may opt to mount with 'nobarrier') on
S2, a fairly common way is to use RSYNC with various preserving
options (run on host S1):

  sudo rsync -i -axAHX --del -z \
     -e 'ssh -oCipher=3Darcfour -oCompression=3Dno -l root' \
     "$M"/ "$S2":"$N"/

The following is another common way that has slightly different
effects on 'atime' and 'ctime' (requires a patched GNU 'tar' or
be replaced with 'star') by using 'ssh' combines with 'tar':

  sudo sh -c "cd '$M' && tar -c --one --selinux --acls --xattrs -f - ." \
  | lzop | dd bs=3D64k iflag=3Dfullblock \
    | ssh -oCipher=3Darcfour -oCompression=3Dno "$S2" \
      "dd bs=3D64k iflag=3Dfullblock | lzop -d \
        | sudo sh -c 'cd \"$N\" && tar -xv --preserve-p --atime-p -f -'"

> xfs_copy would, per documentation,

Probably 'xfs_copy' is only necessary in the case where you
really want to preserve inums, and the source block device is
larger than the target block device (and obviously the size of
the content is smaller than the size of the target block device).

> but can I get from server1 to server2?

That probably requires finding a target medium (file or block
device) big enough and that can be shared (or transported)
between S1 and S2.

This could involve a filetree on S2 that is exported (for example
by NFSv4) to S1 and large enough to hold the target file(s) of
'xfs_copy'.

PS Whichever way is chosen to the copy, a second run with RSYNC
   options '-n -c' might help verify that corruption did not
   happens during the copy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
