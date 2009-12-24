Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBO0GVXN018514 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 18:16:31 -0600
Received: from mail-iw0-f183.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BBEF1350236
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 16:17:11 -0800 (PST)
Received: from mail-iw0-f183.google.com (mail-iw0-f183.google.com
	[209.85.223.183]) by cuda.sgi.com with ESMTP id
	fm9Rjd2a2AnO6uXD for <xfs@oss.sgi.com>;
	Wed, 23 Dec 2009 16:17:11 -0800 (PST)
Received: by iwn13 with SMTP id 13so5288145iwn.20
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 16:17:10 -0800 (PST)
Message-ID: <4B32B303.6070807@gmail.com>
Date: Wed, 23 Dec 2009 17:17:07 -0700
From: ctrn3e8 <ctrn3e8@gmail.com>
MIME-Version: 1.0
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net>
	<87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net>
	<4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp>
	<4B304D04.6040501@byu.net>	<87d427jscr.fsf@devron.myhome.or.jp>
	<4B3097C4.3060803@wanadoo.fr>	<874onjjnln.fsf@devron.myhome.or.jp>
	<4B30B67A.7080703@wanadoo.fr>	<87ljgvi1an.fsf@devron.myhome.or.jp>
	<4B30F0C9.2020702@wanadoo.fr>
	<87my1aevro.fsf@devron.myhome.or.jp> <4B3212ED.4090208@byu.net>
In-Reply-To: <4B3212ED.4090208@byu.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0037169429948719136=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Blake <ebb9@byu.net>
Cc: =?ISO-8859-1?Q?Jean-Pie?=@oss.sgi.com, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, bug-coreutils <bug-coreutils@gnu.org>, =?ISO-8859-1?Q?rre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

--===============0037169429948719136==
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
On 12/23/2009 05:54 AM, Eric Blake wrote:
<blockquote cite="mid:4B3212ED.4090208@byu.net" type="cite">
  <pre wrap="">-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

According to OGAWA Hirofumi on 12/22/2009 10:58 AM:
  </pre>
  <blockquote type="cite">
    <blockquote type="cite">
      <pre wrap="">I suggest I port Miklos patch to fuse-lite soon,
and delay the low-level case (and microsecond
precision) until January. Does that suit your needs ?
      </pre>
    </blockquote>
    <pre wrap="">
Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
bug report on lkml to others. Eric?
    </pre>
  </blockquote>
  <pre wrap="">
I'm also bridging the report from a coreutils user (now cc'd).  Since I
also don't use ntfs-3g, I'm hoping that ctrn3e8 will be able to help test
whether the latest patch to ntfs-3g makes a difference in properly setting
times.  To me, delaying precision while fixing UTIME_OMIT semantics is a
reasonable approach.

By the way, is there any reliable way, other than uname() and checking for
a minimum kernel version, to tell if all file systems will properly
support UTIME_OMIT?  For coreutils 8.3, we will be inserting a workaround
where instead of using UTIME_OMIT, we call fstatat() in advance of
utimensat() and pass the original timestamp down.  But it would be nice to
avoid the penalty of the extra stat if there were a reliable way to ensure
that, regardless of file system, the use of UTIME_OMIT will be honored.
After all, coreutils wants touch(1) to work regardless of how old the
user's kernel and file system drivers are.

- --
Don't work too hard, make some time for fun as well!

Eric Blake             <a class="moz-txt-link-abbreviated" href="mailto:ebb9@byu.net">ebb9@byu.net</a>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Cygwin)
Comment: Public key at home.comcast.net/~ericblake/eblake.gpg
Comment: Using GnuPG with Mozilla - <a class="moz-txt-link-freetext" href="http://enigmail.mozdev.org/">http://enigmail.mozdev.org/</a>

iEYEARECAAYFAksyEu0ACgkQ84KuGfSFAYCrzACgirIjqmS7vFOBcI8xau6jHEa0
4L0AnAjJkje+tSMF/FZkTbkohg/fhQ+i
=ngx0
-----END PGP SIGNATURE-----

  </pre>
</blockquote>
<font face="Arial">I'm okay testing any changes on my ntfs-3g volume.&nbsp;
Also have an XFS volume.&nbsp; Just send me a patch.<br>
<br>
Okay, I don't have the source code in front of me and really do not
know all that is going on,&nbsp; and I am sure I am totally wrong about this
and it will bug everyone,&nbsp; but I do have a stupid question.&nbsp; <br>
<br>
The strace has the following function call&nbsp; (and it may be because I am
looking at the trace rather than the actual source):<br>
<br>
</font>
<pre wrap="">utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0

The third parameter in the call appears to be a struct consisting of (let's assume 32 bit) two longs, so it will layout in memory as:

{
32bits  UTIME_OMIT
32bits  UTIME_NOW
}

The function definition for utimensat is:

<b>int</b> <b>utimensat(int</b> <i>dirfd</i><b>,</b> <b>const</b> <b>char</b> <b>*</b><i>pathname</i><b>,</b>
                     <b>const</b> <b>struct</b> <b>timespec</b> <i>times</i><b>[2],</b> <b>int</b> <i>flags</i><b>);

</b>Note that the third parameter of the definition is an timespec array of 2 elements.

timespec is defined by :

struct timespec {
               time_t tv_sec;        /* seconds */
               long   tv_nsec;       /* nanoseconds */
           };


or consists of two  32 bit longs.

Thus the function expects the following layout in memory for the 3rd parameter:

{
32bits atime seconds
32bits atime nsec
32bits mtime seconds
32bits mtime nsec
}

The two don't seem to match.  Is this just because of the way the trace is printed? Am I missing something?


Also found : <a class="moz-txt-link-freetext" href="http://linux-man-pages.blogspot.com/2008/06/whats-wrong-with-kernel-userland_30.html">http://linux-man-pages.blogspot.com/2008/06/whats-wrong-with-kernel-userland_30.html</a> which has the statement:  "Currently, Linux supports nanosecond timestamps on XFS, JFS, and ext4.". No mention of ntfs-3g support for nanosecond time stamping.



</pre>
<br>
<font face="Arial"><br>
<br>
</font>
</body>
</html>


--===============0037169429948719136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0037169429948719136==--
