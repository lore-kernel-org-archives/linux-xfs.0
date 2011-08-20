Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7KHIcdB166205 for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 12:18:39 -0500
Received: from mail-yi0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FE771DA0C72
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 10:18:37 -0700 (PDT)
Received: from mail-yi0-f53.google.com (mail-yi0-f53.google.com
	[209.85.218.53]) by cuda.sgi.com with ESMTP id zLGXb9DlPtUxGEqn
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 10:18:37 -0700 (PDT)
Received: by yia13 with SMTP id 13so3716377yia.26
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 10:18:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGpXXZ+xjhadprkc_LiP3qUypLLkCxdeEmo8+K+6mOnBuNhmLg@mail.gmail.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<4E4F814B.5070202@gmail.com>
	<CAGpXXZ+xjhadprkc_LiP3qUypLLkCxdeEmo8+K+6mOnBuNhmLg@mail.gmail.com>
Date: Sat, 20 Aug 2011 13:18:37 -0400
Message-ID: <CAGpXXZLa-YgCaTyx4TjORb_vsm-LDV0sinthjMNeb=mR4HqsgA@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
From: Greg Freemyer <greg.freemyer@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3274621313571033471=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>

--===============3274621313571033471==
Content-Type: multipart/alternative; boundary=90e6ba61440653309804aaf3093b

--90e6ba61440653309804aaf3093b
Content-Type: text/plain; charset=ISO-8859-1

On Aug 20, 2011 5:52 AM, "Marco Stornelli" <marco.stornelli@gmail.com>
wrote:
>
> Hi,
>
>
> Il 28/06/2011 17:33, Josef Bacik ha scritto:
>>
>> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.
 Turns out
>> using fiemap in things like cp cause more problems than it solves, so
lets try
>> and give userspace an interface that doesn't suck.  We need to match
solaris
>> here, and the definitions are
>>
>> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
>> next hole greater than or equal to the supplied offset
>> is returned. The definition of a hole is provided near
>> the end of the DESCRIPTION.
>>
>> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
>> start of the next non-hole file region greater than or
>> equal to the supplied offset.
>>
>
> I'm implementing the SEEK_DATA/SEEK_HOLE management for pramfs and I've
got some doubts about the right behavior:
>
> 1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means always
the offset from the start of the file, right?
>
> 2) in case of a file with hole at the beginning and data at the end, if I
do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file because the
idea is to search the *next* hole and we have always a virtual hole at the
end of the file, right?
>
> 3) about the last sentence of point 2), is it always true even if we have
a case of block allocation beyond the end of file (fallocate with keep size
option)?
>

Marco,

You may want to enable the xfstests test(s) for SEEK_HOLE and SEEK_DATA for
pramfs.  That should give you some confidence your implementing the api like
other filesystems are.

Greg

--90e6ba61440653309804aaf3093b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p><br>
On Aug 20, 2011 5:52 AM, &quot;Marco Stornelli&quot; &lt;<a href=3D"mailto:=
marco.stornelli@gmail.com">marco.stornelli@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Hi,<br>
&gt;<br>
&gt;<br>
&gt; Il 28/06/2011 17:33, Josef Bacik ha scritto:<br>
&gt;&gt;<br>
&gt;&gt; This just gets us ready to support the SEEK_HOLE and SEEK_DATA fla=
gs. =A0Turns out<br>
&gt;&gt; using fiemap in things like cp cause more problems than it solves,=
 so lets try<br>
&gt;&gt; and give userspace an interface that doesn&#39;t suck. =A0We need =
to match solaris<br>
&gt;&gt; here, and the definitions are<br>
&gt;&gt;<br>
&gt;&gt; *o* If /whence/ is SEEK_HOLE, the offset of the start of the<br>
&gt;&gt; next hole greater than or equal to the supplied offset<br>
&gt;&gt; is returned. The definition of a hole is provided near<br>
&gt;&gt; the end of the DESCRIPTION.<br>
&gt;&gt;<br>
&gt;&gt; *o* If /whence/ is SEEK_DATA, the file pointer is set to the<br>
&gt;&gt; start of the next non-hole file region greater than or<br>
&gt;&gt; equal to the supplied offset.<br>
&gt;&gt;<br>
&gt;<br>
&gt; I&#39;m implementing the SEEK_DATA/SEEK_HOLE management for pramfs and=
 I&#39;ve got some doubts about the right behavior:<br>
&gt;<br>
&gt; 1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means alw=
ays the offset from the start of the file, right?<br>
&gt;<br>
&gt; 2) in case of a file with hole at the beginning and data at the end, i=
f I do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file because=
 the idea is to search the *next* hole and we have always a virtual hole at=
 the end of the file, right?<br>

&gt;<br>
&gt; 3) about the last sentence of point 2), is it always true even if we h=
ave a case of block allocation beyond the end of file (fallocate with keep =
size option)?<br>
&gt;</p>
<p>Marco,</p>
<p>You may want to enable the xfstests test(s) for SEEK_HOLE and SEEK_DATA =
for pramfs.=A0 That should give you some confidence your implementing the a=
pi like other filesystems are.</p>
<p>Greg</p>

--90e6ba61440653309804aaf3093b--


--===============3274621313571033471==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3274621313571033471==--
