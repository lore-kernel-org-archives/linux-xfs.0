Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 65C9E29DF8
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 11:21:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39440304043
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 09:21:59 -0700 (PDT)
Received: from mail-qa0-f43.google.com (mail-qa0-f43.google.com
	[209.85.216.43]) by cuda.sgi.com with ESMTP id QSCjFvcdAC52BSln
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 01 Jun 2014 09:21:56 -0700 (PDT)
Received: by mail-qa0-f43.google.com with SMTP id m5so1425596qaj.16
	for <xfs@oss.sgi.com>; Sun, 01 Jun 2014 09:21:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140531000117.GM6677@dastard>
References: <CAA43vkVzWRTqNQh2VSi5yvFLtstmVOKRJUnYw_ZSkYJGsex8Uw@mail.gmail.com>
	<20140531000117.GM6677@dastard>
Date: Sun, 1 Jun 2014 12:21:55 -0400
Message-ID: <CAA43vkUBF3q-F6XYTPTVx43KXg_3_COgaK8wtHxRynshOT9smg@mail.gmail.com>
Subject: Re: What to do when... xfs_repair hangs?
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6349183062598128201=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc: xfs@oss.sgi.com

--===============6349183062598128201==
Content-Type: multipart/alternative; boundary=001a11c15f3a5e9a4704fac8adbd

--001a11c15f3a5e9a4704fac8adbd
Content-Type: text/plain; charset=UTF-8

Sorry, all, I was a little out-of-it on Friday afternoon, of course I had
kicked off xfs_repair actually in the background with all output sent to a
file, and I was just doing 'tail -f' on that file.

So I kill the 'tail -f' and jump back to the command line, it appears that
xfs_repair segfaulted and died.

That line of text:

disconnected inode 1109099673,

was indeed the last thing that it printed before it crashed.

If I look in dmesg, I just see -

xfs_repair[6770]: segfault at 28 ip 000000000042307b sp 00007fffef61bad0
error 4 in xfs_repair[400000+72000]

and that's it.

I checked with 'df' and there's plenty of space everywhere; I don't see why
it would have faulted out trying to connect something to lost+found.

Underlying storage should be good; this is basically a RAID 60 built on top
of a bunch of JBODs with LSI SAS9200 cards. MD sees all strings as started
and running OK; no problems getting the array assembled at all.

Since Dave is saying it's OK to try re-running xfs_repair; it'll just pick
up where it left off; let me give it another pass and see if it manages to
complete, or if it segfaults out again. I guess it it poops out a second
time, maybe we'll just want to consider rebuilding the filesystem and
restoring from our copies?

Thanks for the feedback,

Sean



On Fri, May 30, 2014 at 8:01 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, May 30, 2014 at 03:49:13PM -0400, Sean Caron wrote:
> > Hi all,
> >
> > Long story short, we have a big array formatted as XFS, we had a machine
> go
> > down hard maybe a month, month and a half ago... when it came back up,
> XFS
> > faulted out when we attempted to mount the filesystem; it complained the
> > log was bad or something... I did a dry run of xfs_repair (-L) and it
> > looked pretty bad, so we mounted up the filesystem read-only, ran a
> > backup... I think we got pretty much everything out OK except maybe files
> > that were open at the time of the crash.
> >
> > Now with a backup in hand, we kicked off xfs_repair "for real"... it ran
> > for a while and did its thing, but now it appears to be stuck at the
> stage -
> >
> > - agno = 436
> > rebuilding directory inode ...
> > rebuilding directory inode ...
> > rebuilding directory inode ...
> > ...
> > - traversal finished ...
> > - moving disconected inodes to lost+found ...
> > disconnected inode 1109099673,
> >
> > and then it just stops. I don't know how long its been sitting like that,
> > but it hasn't moved in the last hour or two. I assume that's not good...
>
> Is that the total of the last line of output? If so, it's likely
> stuck creating the lost+found directory. It's possible there's a
> corruption in the inode AVL tree (e.g. endless loop) that is causing
> it to spin doing an inode record lookup, but otherwise I can't see
> any reason for it getting stuck here.
>
> The information that Brian asked for will be a good start in
> tracking this down, as will the complete output of xfs_repair...
>
> > Interestingly when we ran a dry run of xfs_repair (-L) it got all the way
> > through; it never hung up at any point. Not sure why it would start to
> hang
> > up, once it gets run "for real".
>
> That's because a dry-run skips the "move to lost_found" phase.
>
> > This machine is in single-user-mode, I have exactly 24 lines of console
> > with no scrollback buffer, no other tty available besides that which I'm
> > running xfs_repair on, the system console.
>
> $ man script
>
> or
>
> $ man tee
>
> > Running Linux kernel 3.4.61, Ubuntu 12.04 LTS 64-bit with whatever their
> > current xfsprogs is.
>
> Upgrading xfsprogs to 3.2.0 would be a good idea.
>
> > This is a bit of an exceptional situation for me; I've never seen
> > xfs_repair just hang outright. I hoped I could maybe get some feedback
> from
> > the experts here... what should I do?
> >
> > Try to Control-C out of the xfs_repair and ... re-run it?
>
> That's fine - the next time repair runs it will start again and
> repair anything that wasn't repaired in the last run.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11c15f3a5e9a4704fac8adbd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry, all, I was a little out-of-it on Friday afternoon, =
of course I had kicked off xfs_repair actually in the background with all o=
utput sent to a file, and I was just doing &#39;tail -f&#39; on that file.<=
div>
<br></div><div>So I kill the &#39;tail -f&#39; and jump back to the command=
 line, it appears that xfs_repair segfaulted and died.</div><div><br></div>=
<div>That line of text:</div><div><br></div><div><span style=3D"color:rgb(8=
0,0,80);font-family:arial,sans-serif;font-size:13.333333969116211px">discon=
nected inode 1109099673,</span><br>
</div><div><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;f=
ont-size:13.333333969116211px"><br></span></div><div><span style=3D"color:r=
gb(80,0,80);font-family:arial,sans-serif;font-size:13.333333969116211px">wa=
s indeed the last thing that it printed before it crashed.</span></div>
<div><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-si=
ze:13.333333969116211px"><br></span></div><div><span style=3D"color:rgb(80,=
0,80);font-family:arial,sans-serif;font-size:13.333333969116211px">If I loo=
k in dmesg, I just see -</span></div>
<div><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-si=
ze:13.333333969116211px"><br></span></div><div><span style=3D"color:rgb(80,=
0,80);font-family:arial,sans-serif;font-size:13.333333969116211px">xfs_repa=
ir[6770]: segfault at 28 ip 000000000042307b sp 00007fffef61bad0 error 4 in=
 xfs_repair[400000+72000]</span></div>
<div><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-si=
ze:13.333333969116211px"><br></span></div><div><span style=3D"color:rgb(80,=
0,80);font-family:arial,sans-serif;font-size:13.333333969116211px">and that=
&#39;s it.</span></div>
<div><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-si=
ze:13.333333969116211px"><br></span></div><div><span style=3D"color:rgb(80,=
0,80);font-family:arial,sans-serif;font-size:13.333333969116211px">I checke=
d with &#39;df&#39; and there&#39;s plenty of space everywhere; I don&#39;t=
 see why it would have faulted out trying to connect something to lost+foun=
d.</span></div>
<div><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-si=
ze:13.333333969116211px"><br></span></div><div><span style=3D"color:rgb(80,=
0,80);font-family:arial,sans-serif;font-size:13.333333969116211px">Underlyi=
ng storage should be good; this is basically a RAID 60 built on top of a bu=
nch of JBODs with LSI SAS9200 cards. MD sees all strings as started and run=
ning OK; no problems getting the array assembled at all.</span></div>
<div><span style=3D"color:rgb(80,0,80);font-family:arial,sans-serif;font-si=
ze:13.333333969116211px"><br></span></div><div><font color=3D"#500050" face=
=3D"arial, sans-serif">Since Dave is saying it&#39;s OK to try re-running x=
fs_repair; it&#39;ll just pick up where it left off; let me give it another=
 pass and see if it manages to complete, or if it segfaults out again. I gu=
ess it it poops out a second time, maybe we&#39;ll just want to consider re=
building the filesystem and restoring from our copies?</font></div>
<div><br></div><div><font color=3D"#500050" face=3D"arial, sans-serif">Than=
ks for the feedback,</font></div><div><font color=3D"#500050" face=3D"arial=
, sans-serif"><br></font></div><div><font color=3D"#500050" face=3D"arial, =
sans-serif">Sean</font></div>
<div><font color=3D"#500050" face=3D"arial, sans-serif"><br></font></div></=
div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, M=
ay 30, 2014 at 8:01 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span>=
 wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Fri, May 30, 2014 at 03:4=
9:13PM -0400, Sean Caron wrote:<br>
</div><div class=3D"">&gt; Hi all,<br>
&gt;<br>
&gt; Long story short, we have a big array formatted as XFS, we had a machi=
ne go<br>
&gt; down hard maybe a month, month and a half ago... when it came back up,=
 XFS<br>
&gt; faulted out when we attempted to mount the filesystem; it complained t=
he<br>
&gt; log was bad or something... I did a dry run of xfs_repair (-L) and it<=
br>
&gt; looked pretty bad, so we mounted up the filesystem read-only, ran a<br=
>
&gt; backup... I think we got pretty much everything out OK except maybe fi=
les<br>
&gt; that were open at the time of the crash.<br>
&gt;<br>
&gt; Now with a backup in hand, we kicked off xfs_repair &quot;for real&quo=
t;... it ran<br>
&gt; for a while and did its thing, but now it appears to be stuck at the s=
tage -<br>
&gt;<br>
&gt; - agno =3D 436<br>
&gt; rebuilding directory inode ...<br>
&gt; rebuilding directory inode ...<br>
&gt; rebuilding directory inode ...<br>
&gt; ...<br>
&gt; - traversal finished ...<br>
&gt; - moving disconected inodes to lost+found ...<br>
&gt; disconnected inode 1109099673,<br>
&gt;<br>
&gt; and then it just stops. I don&#39;t know how long its been sitting lik=
e that,<br>
&gt; but it hasn&#39;t moved in the last hour or two. I assume that&#39;s n=
ot good...<br>
<br>
</div>Is that the total of the last line of output? If so, it&#39;s likely<=
br>
stuck creating the lost+found directory. It&#39;s possible there&#39;s a<br=
>
corruption in the inode AVL tree (e.g. endless loop) that is causing<br>
it to spin doing an inode record lookup, but otherwise I can&#39;t see<br>
any reason for it getting stuck here.<br>
<br>
The information that Brian asked for will be a good start in<br>
tracking this down, as will the complete output of xfs_repair...<br>
<div class=3D""><br>
&gt; Interestingly when we ran a dry run of xfs_repair (-L) it got all the =
way<br>
&gt; through; it never hung up at any point. Not sure why it would start to=
 hang<br>
&gt; up, once it gets run &quot;for real&quot;.<br>
<br>
</div>That&#39;s because a dry-run skips the &quot;move to lost_found&quot;=
 phase.<br>
<div class=3D""><br>
&gt; This machine is in single-user-mode, I have exactly 24 lines of consol=
e<br>
&gt; with no scrollback buffer, no other tty available besides that which I=
&#39;m<br>
&gt; running xfs_repair on, the system console.<br>
<br>
</div>$ man script<br>
<br>
or<br>
<br>
$ man tee<br>
<div class=3D""><br>
&gt; Running Linux kernel 3.4.61, Ubuntu 12.04 LTS 64-bit with whatever the=
ir<br>
&gt; current xfsprogs is.<br>
<br>
</div>Upgrading xfsprogs to 3.2.0 would be a good idea.<br>
<div class=3D""><br>
&gt; This is a bit of an exceptional situation for me; I&#39;ve never seen<=
br>
&gt; xfs_repair just hang outright. I hoped I could maybe get some feedback=
 from<br>
&gt; the experts here... what should I do?<br>
&gt;<br>
&gt; Try to Control-C out of the xfs_repair and ... re-run it?<br>
<br>
</div>That&#39;s fine - the next time repair runs it will start again and<b=
r>
repair anything that wasn&#39;t repaired in the last run.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--001a11c15f3a5e9a4704fac8adbd--


--===============6349183062598128201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6349183062598128201==--
