Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE0157F58
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 08:17:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CB964304048
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 06:17:02 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id 4ShGlsAs0XRauQHF
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 04 Nov 2014 06:17:01 -0800 (PST)
From: "Meij, Henk" <hmeij@wesleyan.edu>
Subject: RE: clone of filesystem across network preserving ionodes
Date: Tue, 4 Nov 2014 14:16:59 +0000
Message-ID: <8688BD11DAC0574AA90295127E9E9F4AC047FECB@exchangewes8.wesad.wesleyan.edu>
References: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>,
	<21592.6241.228215.412783@tree.ty.sabi.co.uk>
In-Reply-To: <21592.6241.228215.412783@tree.ty.sabi.co.uk>
Content-Language: en-US
MIME-Version: 1.0
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
To: Peter Grandi <pg@xfs.list.sabi.co.UK>, Linux fs XFS <xfs@oss.sgi.com>

Thank you list, I think the problem is in my work flow, and in my head.  I =
will be testing some suggestions and will report back. To answer some of th=
e questions:

S1 and S2 are identical research storage units (112TB each) partitioned in =
4 28TB partitions, with duplicate data for fail over purposes (exceeds out =
enterprise backup capacity, cheaper this way).

DRBD is where we started. v8.4.5 was tested but could not deliver rates lar=
ger than 40MB/s, despite the lists excellent suggestions. We're unsure why;=
 we ran w/wo BBU, changed RW policies, configured 2 global hot spares into =
raid 0, even made ram disks, multiple drbd devices, but the storage unit (x=
fs on raid 60) never obtained the "want" speeds of 100MB/s. rsync tests had=
 no problems reaching 112MB/s and slightly better nic-to-nic. First initial=
ization/re-sync times for DRBD would be 30 days unless fixed.

So we're building our own. Pulling data from multiple locations to seed S1,=
 then use rsync or xfsdump to seed S2. Manual fail over of service IP with =
scripts. Nightly incrementals. We'd like to run daily, weekly, monthly snap=
shots on S2. We do that with the --link-dest=3D/path/to/d.1 /path/to/source=
 /path/to/d.0   ... now the first daily snapshot (d.0) will be as large as =
the source.  And that's what I like to avoid (having 3 copies) so I need to=
 change my thinking and present the S2 copy to --link-dest as the latest ba=
ckup.

-Henk

________________________________________
From: xfs-bounces@oss.sgi.com [xfs-bounces@oss.sgi.com] on behalf of Peter =
Grandi [pg@xfs.list.sabi.co.UK]
Sent: Monday, November 03, 2014 7:05 PM
To: Linux fs XFS
Subject: Re: clone of filesystem across network preserving ionodes

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
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
