Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7FM7L3159165 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 09:22:07 -0600
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id TT0kHpSHrM9KSDXA
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Nov 2012 07:24:03 -0800 (PST)
Received: by mail-vb0-f53.google.com with SMTP id fc21so1724546vbb.26
	for <xfs@oss.sgi.com>; Wed, 07 Nov 2012 07:24:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121101225938.GS29378@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
Date: Wed, 7 Nov 2012 07:24:03 -0800
Message-ID: <CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
From: Aaron Goulding <aarongldng@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2151820566985240356=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2151820566985240356==
Content-Type: multipart/alternative; boundary=047d7b6d9340fe798404cde94eeb

--047d7b6d9340fe798404cde94eeb
Content-Type: text/plain; charset=ISO-8859-1

root@jarvis:~# xfs_db -V
xfs_db version 3.1.7

I'm sorry for the delay in response. I've had to work on several other
projects as well, and thank you for the assistance. :)

So I ran a check using bgrep to find all instances of XFSB on /dev/md1 and
came up with just over 3000 results. It's easy enough to write up something
to go grab 100-200 bytes at each point, but I wonder if there's something I
can improve on the bgrep search to narrow that result list down a bit?

Thanks Again!

-Aaron




On Thu, Nov 1, 2012 at 3:59 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Oct 30, 2012 at 10:02:28PM -0700, Aaron Goulding wrote:
> > Hello! So I have an XFS filesystem that isn't mounting, and quite a long
> > story as to why and what I've tried.
> >
> > And before you start, yes backups are the preferred method of restoration
> > at this point. Never trust your files to a single FS, etc.
>
> It's kind of assumed knowledge round here or that there are good
> reasons for not backing up the filesystem (e.g. it's hard to back up
> a 500TB filesystem).
>
> [snip raid horror story]
>
> > Once I had the file created, I tried xfs_clean -f /mnt/restore/md0.dat to
> > no luck. I used a hex editor to add XFSB to be beginning, hoping the
>
> That won't work - the magic number is just one of many checks on the
> superblock before it can be considered valid.
>
> > recovery would just clean around the LVM data with similar results. The
> > result looks like the following:
> >
> > Phase 1 - find and verify superblock...
> > bad primary superblock - bad or unsupported version !!!
>
> And that's the second check :/
>
> > attempting to find secondary superblock...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > unable to verify superblock, continuing...
> >
> ....................................................................................................
> > Exiting now.
>
> So, that means if found 10 potential secondary superblocks, but
> couldn't validate any of them. Can you find those superblocks and
> hexdump them? something like:
>
> hexdump <dev or file> | grep -A 30 XFSB
>
> Also of interest would be to hexdump the subsequent sector as well,
> it should have a magic number of XAGF, and will also have a sequence
> number in it that should help tell us if you've got everything in
> order.
>
> > running xfs_db /mnt/restore/md0.dat would appear to run out of memory.
>
> No surprise there if the superblocks are toast.
>
> > Next I tried xfs_db /dev/md1 to see if anything would load. I get the
> > following:
> >
> > root@jarvis:/mnt# xfs_db /dev/md1
> > Floating point exception
> >
> > With the following in dmesg:
> >
> > [1568395.691767] xfs_db[30966] trap divide error ip:41e4b5
> sp:7fff5db8ab90
> > error:0 in xfs_db[400000+6a000]
>
> what version are you running?
>
> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b6d9340fe798404cde94eeb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

root@jarvis:~# xfs_db -V<br>xfs_db version 3.1.7<br><br>I&#39;m sorry for t=
he delay in response. I&#39;ve had to work on several other projects as wel=
l, and thank you for the assistance. :)<br><br>So I ran a check using bgrep=
 to find all instances of XFSB on /dev/md1 and came up with just over 3000 =
results. It&#39;s easy enough to write up something to go grab 100-200 byte=
s at each point, but I wonder if there&#39;s something I can improve on the=
 bgrep search to narrow that result list down a bit? <br>
<br>Thanks Again!<br><br>-Aaron<br><br><br>
<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Thu, Nov 1=
, 2012 at 3:59 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:dav=
id@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrot=
e:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Tue, Oct 30, 2012 at 10=
:02:28PM -0700, Aaron Goulding wrote:<br>
&gt; Hello! So I have an XFS filesystem that isn&#39;t mounting, and quite =
a long<br>
&gt; story as to why and what I&#39;ve tried.<br>
&gt;<br>
&gt; And before you start, yes backups are the preferred method of restorat=
ion<br>
&gt; at this point. Never trust your files to a single FS, etc.<br>
<br>
</div>It&#39;s kind of assumed knowledge round here or that there are good<=
br>
reasons for not backing up the filesystem (e.g. it&#39;s hard to back up<br=
>
a 500TB filesystem).<br>
<br>
[snip raid horror story]<br>
<div class=3D"im"><br>
&gt; Once I had the file created, I tried xfs_clean -f /mnt/restore/md0.dat=
 to<br>
&gt; no luck. I used a hex editor to add XFSB to be beginning, hoping the<b=
r>
<br>
</div>That won&#39;t work - the magic number is just one of many checks on =
the<br>
superblock before it can be considered valid.<br>
<div class=3D"im"><br>
&gt; recovery would just clean around the LVM data with similar results. Th=
e<br>
&gt; result looks like the following:<br>
&gt;<br>
&gt; Phase 1 - find and verify superblock...<br>
&gt; bad primary superblock - bad or unsupported version !!!<br>
<br>
</div>And that&#39;s the second check :/<br>
<div class=3D"im"><br>
&gt; attempting to find secondary superblock...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; unable to verify superblock, continuing...<br>
&gt; ......................................................................=
..............................<br>
&gt; Exiting now.<br>
<br>
</div>So, that means if found 10 potential secondary superblocks, but<br>
couldn&#39;t validate any of them. Can you find those superblocks and<br>
hexdump them? something like:<br>
<br>
hexdump &lt;dev or file&gt; | grep -A 30 XFSB<br>
<br>
Also of interest would be to hexdump the subsequent sector as well,<br>
it should have a magic number of XAGF, and will also have a sequence<br>
number in it that should help tell us if you&#39;ve got everything in<br>
order.<br>
<div class=3D"im"><br>
&gt; running xfs_db /mnt/restore/md0.dat would appear to run out of memory.=
<br>
<br>
</div>No surprise there if the superblocks are toast.<br>
<div class=3D"im"><br>
&gt; Next I tried xfs_db /dev/md1 to see if anything would load. I get the<=
br>
&gt; following:<br>
&gt;<br>
&gt; root@jarvis:/mnt# xfs_db /dev/md1<br>
&gt; Floating point exception<br>
&gt;<br>
&gt; With the following in dmesg:<br>
&gt;<br>
&gt; [1568395.691767] xfs_db[30966] trap divide error ip:41e4b5 sp:7fff5db8=
ab90<br>
&gt; error:0 in xfs_db[400000+6a000]<br>
<br>
</div>what version are you running?<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--047d7b6d9340fe798404cde94eeb--


--===============2151820566985240356==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2151820566985240356==--
