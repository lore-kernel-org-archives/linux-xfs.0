Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECD2829E09
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 17:16:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2CE8304066
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 15:16:12 -0800 (PST)
Received: from mail-qa0-f43.google.com (mail-qa0-f43.google.com
	[209.85.216.43]) by cuda.sgi.com with ESMTP id u75ZPftCrUZ18yQb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Dec 2013 15:16:10 -0800 (PST)
Received: by mail-qa0-f43.google.com with SMTP id ii20so1045597qab.9
	for <xfs@oss.sgi.com>; Fri, 06 Dec 2013 15:16:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
	<52A03513.6030408@hardwarefreak.com>
	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>
	<CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>
	<52A191BA.20800@hardwarefreak.com>
	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>
From: Mike Dacre <mike.dacre@gmail.com>
Date: Fri, 6 Dec 2013 15:15:29 -0800
Message-ID: <CAPd9ww8CB7vhJR78XeM9bw-=PRf23KPmrVe73WGsBcsgwVEmaQ@mail.gmail.com>
Subject: Fwd: Fwd: Sudden File System Corruption
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3375961669763108226=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3375961669763108226==
Content-Type: multipart/alternative; boundary=001a1134b048da095704ece5d418

--001a1134b048da095704ece5d418
Content-Type: text/plain; charset=UTF-8

---------- Forwarded message ----------
From: Mike Dacre <mike.dacre@gmail.com>
Date: Fri, Dec 6, 2013 at 2:14 PM
Subject: Re: Fwd: Sudden File System Corruption
To: stan@hardwarefreak.com





On Fri, Dec 6, 2013 at 12:58 AM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 12/5/2013 9:58 AM, Mike Dacre wrote:
>
> > On Thu, Dec 5, 2013 at 12:10 AM, Stan Hoeppner <stan@hardwarefreak.com
> >wrote:
> >> On 12/4/2013 8:55 PM, Mike Dacre wrote:
> >> ...
> >
> > Definitely RAID6
> >
> > 2.  Strip size?  (eg 512KB)
> >>
> > 64KB
>
> Ok, so 64*14 = 896KB stripe.  This seems pretty sane for a 14 spindle
> parity array and mixed workloads.
>
> > 4.  BBU module?
> >>
> > Yes. iBBU, state optimal, 97% charged.
> >
> > 5.  Is write cache enabled?
> >>
> >> Yes: Cahced IO and Write Back with BBU are enabled.
>
> I should have pointed you this this earlier:
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
>
> but we've got most of it already.  We don't have your fstab mount
> options.  Please provide that.
>

UUID=a58bf1db-0d64-4a2d-8e03-aad78dbebcbe /science                xfs
defaults,inode64          1 0

On the slave nodes, I managed to reduce the demand on the disks by adding
the actimeo=60 mount option.  Prior to doing this I would sometimes see the
disk being negatively affected by enormous numbers of getattr requests.
 Here is the fstab mount on the nodes:

192.168.2.1:/science                      /science                nfs
defaults,vers=3,nofail,actimeo=60,bg,hard,intr,rw  0 0

...
> > This is also attached as xfs_info.txt
>
> You're not aligning XFS to the RAID geometry (unless you're overriding
> in fstab).  No alignment is good though for small (<896KB) file
> allocations but less than optimal for large streaming allocation writes.
>  But it isn't a factor in the problems you reported.
>
>
Correct, I am not consciously aligning the XFS to the RAID geometry, I
actually didn't know that was possible.


> ...
> >> Good point.  These happened while trying to ls.  I am not sure why I
> can't
> > find them in the log, they printed out to the console as 'Input/Output'
> > errors, simply stating that the ls command failed.
>
> We look for SCSI IO errors preceding an XFS error as a causal indicator.
>  I didn't see that here.  You could have run into the bug Ben described
> earlier.  I can't really speak to the console errors.
>
> >> With delaylog enabled, which I believe it is in RHEL/CentOS 6, a single
> >> big rm shouldn't kill the disks.  But with the combination of other
> >> workloads it seems you may have been seeking the disks to death.
> >>
> > That is possible, workloads can get really high sometimes.  I am not sure
> > how to control that without significantly impacting performance - I want
> a
> > single user to be able to use 98% IO capacity sometimes... but other
> times
> > I want the load to be split amongst many users.
>
> You can't control the seeking at the disks.  You can only schedule
> workloads together that don't compete for seeks.  And if you have one
> metadata or random read/write heavy workload, with this SATA RAID6
> array, it will need exclusive access for the duration of execution, or
> the portion that does all the random IO.  Otherwise other workloads
> running concurrently will crawl while competing for seek bandwidth.
>
> > Also, each user can
> > execute jobs simultaneously on 23 different computers, each acessing the
> > same drive via NFS.  This is a great system most of the time, but
> sometimes
> > the workloads on the drive get really high.
>
> So it's a small compute cluster using NFS over Infiniband for shared
> file access to a low performance RAID6 array.  The IO resource sharing
> is automatic.  But AFAIK there's no easy way to enforce IO quotas on
> users or processes, if at all.  You may simply not have sufficient IO to
> go around.  Let's ponder that.
>

I have tried a few things to improve IO allocation.  BetterLinux have a
cgroup control suite that allow on-the-fly user-level IO adjustments,
however I found them to be quite cumbersome.

I considered an ugly hack in which I would run two NFS servers, one on the
network to the login node, and one on the network to the other nodes, so
that I could use cgroups to limit IO by process, effectively guaranteeing a
5% IO capacity window to the login node, even if the compute nodes were all
going crazy.  I quickly came to the conclusion that I don't know enough
about filesystems, nfs, or the linux kernel to do this effectively: I would
almost certainly just make an ugly mess that accomplished little more than
breaking a lot of things, while not solving the problem.  I still think it
is a good idea in principle though, I just recognize that it would need to
be implemented by someone with a lot more experience than me, and that it
would probably be a major undertaking.


> Looking at the math, you currently have approximately 14*150=2100
> seeks/sec capability with 14x 7.2k RPM data spindles.  That's less than
> 100 seeks/sec per compute node, i.e. each node is getting about 2/3rd of
> the performance of a single SATA disk from this array.  This simply
> isn't sufficient for servicing a 23 node cluster, unless all workloads
> are compute bound, and none IO/seek bound.  Given the overload/crash
> that brought you to our attention, I'd say some of your workloads are
> obviously IO/seek bound.  I'd say you probably need more/faster disks.
> Or you need to identify which jobs are IO/seek heavy and schedule them
> so they're not running concurrently.
>

Yes, this is a problem.  We sadly lack the resources to do much better than
this, we have recently been adding extra storage by just chaining together
USB3 drives with RAID and LVM... which is cumbersome and slow, but cheaper.

My current solution is to be on the alert for high IO jobs, and to move
them to a specific torque queue that limits the number of concurrent jobs.
 This works, but I have not found a way to do it automatically.
 Thankfully, with a 12 member lab, it is actually not terribly complex to
handle, but I would definitely prefer a more comprehensive solution.  I
don't doubt that the huge IO and seek demands we put on these disks will
cause more problems in the future.


> ...
> >>
> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E
> >>
> >> "As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much
> >> of the parallelization in XFS."
> ...
> >> echo deadline > /sys/block/sda/queue/scheduler
> >>
> > Wow, this is huge, I can't believe I missed that.  I have switched it to
> > noop now as we use write caching.  I have been trying to figure out for a
> > while why I would keep getting timeouts when the NFS load was high.  If
> you
> > have any other suggestions for how I can improve performance, I would
> > greatly appreciate it.
>
> This may not fix NFS timeouts entirely but it should help.  If the NFS
> operations are seeking the disks to death you may still see timeouts.
>
> >> This one simple command line may help pretty dramatically, immediately,
> >> assuming your hardware array parameters aren't horribly wrong for your
> >> workloads, and your XFS alignment correctly matches the hardware
> geometry.
> >>
> > Great, thanks.  Our workloads vary considerably as we are a biology
> > research lab, sometimes we do lots of seeks, other times we are almost
> > maxing out read or write speed with massively parallel processes all
> > accessing the disk at the same time.
>
> Do you use munin or something similar?  Sample output:
>
> http://demo.munin-monitoring.org/munin-monitoring.org/demo.munin-monitoring.org/index.html#disk
>
> Project page:
> http://munin-monitoring.org/


I have been using Ganglia, but it doesn't have good NFS monitoring as far
as I can tell.  I will check out Munin, thanks for the advice.


> It also has an NFS module and many others.  The storage oriented metrics
> may be very helpful to you.  You would install munin-node on the NFS
> server and all compute nodes, and munin on a collector/web server.  This
> will allow you to cross reference client and server NFS loads.  You can
> then cross reference the time in your PBS logs to see which users were
> running which jobs when IO spikes occur on the NFS server.  You'll know
> exactly which workloads, or combination thereof, are causing IO spikes.
>
> --
> Stan
>

-Mike

--001a1134b048da095704ece5d418
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br><div class=3D"gmail_quote">---------- Forwarded me=
ssage ----------<br>From: <b class=3D"gmail_sendername">Mike Dacre</b> <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:mike.dacre@gmail.com">mike.dacre@gmail.=
com</a>&gt;</span><br>

Date: Fri, Dec 6, 2013 at 2:14 PM<br>Subject: Re: Fwd: Sudden File System C=
orruption<br>To: <a href=3D"mailto:stan@hardwarefreak.com">stan@hardwarefre=
ak.com</a><br><br><br><div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><=
br>

<div class=3D"gmail_quote"><div class=3D"im">On Fri, Dec 6, 2013 at 12:58 A=
M, Stan Hoeppner <span dir=3D"ltr">&lt;<a href=3D"mailto:stan@hardwarefreak=
.com" target=3D"_blank">stan@hardwarefreak.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div>On 12/5/2013 9:58 AM, Mike Dacre wrote:<br>

<br>
&gt; On Thu, Dec 5, 2013 at 12:10 AM, Stan Hoeppner &lt;<a href=3D"mailto:s=
tan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.com</a>&gt;wrot=
e:<br>
&gt;&gt; On 12/4/2013 8:55 PM, Mike Dacre wrote:<br>
&gt;&gt; ...<br>
&gt;<br>
</div><div>&gt; Definitely RAID6<br>
&gt;<br>
&gt; 2. =C2=A0Strip size? =C2=A0(eg 512KB)<br>
&gt;&gt;<br>
&gt; 64KB<br>
<br>
</div>Ok, so 64*14 =3D 896KB stripe. =C2=A0This seems pretty sane for a 14 =
spindle<br>
parity array and mixed workloads.<br>
<div><br>
&gt; 4. =C2=A0BBU module?<br>
&gt;&gt;<br>
&gt; Yes. iBBU, state optimal, 97% charged.<br>
&gt;<br>
&gt; 5. =C2=A0Is write cache enabled?<br>
&gt;&gt;<br>
&gt;&gt; Yes: Cahced IO and Write Back with BBU are enabled.<br>
<br>
</div>I should have pointed you this this earlier:<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_in=
clude_when_reporting_a_problem.3F" target=3D"_blank">http://xfs.org/index.p=
hp/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F=
</a><br>



<br>
but we&#39;ve got most of it already. =C2=A0We don&#39;t have your fstab mo=
unt<br>
options. =C2=A0Please provide that.<br></blockquote><div>=C2=A0</div></div>=
<div>UUID=3Da58bf1db-0d64-4a2d-8e03-aad78dbebcbe /science =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0xfs =C2=A0 =C2=A0 defaults,inode64 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 0=C2=A0</div><div><br></div><div>On the=
 slave nodes, I managed to reduce the demand on the disks by adding the act=
imeo=3D60 mount option. =C2=A0Prior to doing this I would sometimes see the=
 disk being negatively affected by enormous numbers of getattr requests. =
=C2=A0Here is the fstab mount on the nodes:</div>


<div><br></div><div>192.168.2.1:/science =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/science =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nfs =C2=A0 =C2=A0 defaults,vers=3D3,nofail,a=
ctimeo=3D60,bg,hard,intr,rw =C2=A00 0<br></div><div class=3D"im"><div><br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:so=
lid;padding-left:1ex">



...<br>
<div>&gt; This is also attached as xfs_info.txt<br>
<br>
</div>You&#39;re not aligning XFS to the RAID geometry (unless you&#39;re o=
verriding<br>
in fstab). =C2=A0No alignment is good though for small (&lt;896KB) file<br>
allocations but less than optimal for large streaming allocation writes.<br=
>
=C2=A0But it isn&#39;t a factor in the problems you reported.<br>
<br></blockquote><div><br></div></div><div>Correct, I am not consciously al=
igning the XFS to the RAID geometry, I actually didn&#39;t know that was po=
ssible.</div><div><div class=3D"h5"><div>=C2=A0</div><blockquote class=3D"g=
mail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-=
left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">



...<br>
<div>&gt;&gt; Good point. =C2=A0These happened while trying to ls. =C2=A0I =
am not sure why I can&#39;t<br>
&gt; find them in the log, they printed out to the console as &#39;Input/Ou=
tput&#39;<br>
&gt; errors, simply stating that the ls command failed.<br>
<br>
</div>We look for SCSI IO errors preceding an XFS error as a causal indicat=
or.<br>
=C2=A0I didn&#39;t see that here. =C2=A0You could have run into the bug Ben=
 described<br>
earlier. =C2=A0I can&#39;t really speak to the console errors.<br>
<div><br>
&gt;&gt; With delaylog enabled, which I believe it is in RHEL/CentOS 6, a s=
ingle<br>
&gt;&gt; big rm shouldn&#39;t kill the disks. =C2=A0But with the combinatio=
n of other<br>
&gt;&gt; workloads it seems you may have been seeking the disks to death.<b=
r>
&gt;&gt;<br>
&gt; That is possible, workloads can get really high sometimes. =C2=A0I am =
not sure<br>
&gt; how to control that without significantly impacting performance - I wa=
nt a<br>
&gt; single user to be able to use 98% IO capacity sometimes... but other t=
imes<br>
&gt; I want the load to be split amongst many users.<br>
<br>
</div>You can&#39;t control the seeking at the disks. =C2=A0You can only sc=
hedule<br>
workloads together that don&#39;t compete for seeks. =C2=A0And if you have =
one<br>
metadata or random read/write heavy workload, with this SATA RAID6<br>
array, it will need exclusive access for the duration of execution, or<br>
the portion that does all the random IO. =C2=A0Otherwise other workloads<br=
>
running concurrently will crawl while competing for seek bandwidth.<br>
<div><br>
&gt; Also, each user can<br>
&gt; execute jobs simultaneously on 23 different computers, each acessing t=
he<br>
&gt; same drive via NFS. =C2=A0This is a great system most of the time, but=
 sometimes<br>
&gt; the workloads on the drive get really high.<br>
<br>
</div>So it&#39;s a small compute cluster using NFS over Infiniband for sha=
red<br>
file access to a low performance RAID6 array. =C2=A0The IO resource sharing=
<br>
is automatic. =C2=A0But AFAIK there&#39;s no easy way to enforce IO quotas =
on<br>
users or processes, if at all. =C2=A0You may simply not have sufficient IO =
to<br>
go around. =C2=A0Let&#39;s ponder that.<br></blockquote><div><br></div></di=
v></div><div>I have tried a few things to improve IO allocation. =C2=A0Bett=
erLinux have a cgroup control suite that allow on-the-fly user-level IO adj=
ustments, however I found them to be quite cumbersome.</div>


<div><br></div><div>I considered an ugly hack in which I would run two NFS =
servers, one on the network to the login node, and one on the network to th=
e other nodes, so that I could use cgroups to limit IO by process, effectiv=
ely guaranteeing a 5% IO capacity window to the login node, even if the com=
pute nodes were all going crazy. =C2=A0I quickly came to the conclusion tha=
t I don&#39;t know enough about filesystems, nfs, or the linux kernel to do=
 this effectively: I would almost certainly just make an ugly mess that acc=
omplished little more than breaking a lot of things, while not solving the =
problem. =C2=A0I still think it is a good idea in principle though, I just =
recognize that it would need to be implemented by someone with a lot more e=
xperience than me, and that it would probably be a major undertaking.</div>

<div class=3D"im">
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex">
Looking at the math, you currently have approximately 14*150=3D2100<br>
seeks/sec capability with 14x 7.2k RPM data spindles. =C2=A0That&#39;s less=
 than<br>
100 seeks/sec per compute node, i.e. each node is getting about 2/3rd of<br=
>
the performance of a single SATA disk from this array. =C2=A0This simply<br=
>
isn&#39;t sufficient for servicing a 23 node cluster, unless all workloads<=
br>
are compute bound, and none IO/seek bound. =C2=A0Given the overload/crash<b=
r>
that brought you to our attention, I&#39;d say some of your workloads are<b=
r>
obviously IO/seek bound. =C2=A0I&#39;d say you probably need more/faster di=
sks.<br>
Or you need to identify which jobs are IO/seek heavy and schedule them<br>
so they&#39;re not running concurrently.<br></blockquote><div><br></div></d=
iv><div>Yes, this is a problem. =C2=A0We sadly lack the resources to do muc=
h better than this, we have recently been adding extra storage by just chai=
ning together USB3 drives with RAID and LVM... which is cumbersome and slow=
, but cheaper.</div>


<div><br></div><div>My current solution is to be on the alert for high IO j=
obs, and to move them to a specific torque queue that limits the number of =
concurrent jobs. =C2=A0This works, but I have not found a way to do it auto=
matically. =C2=A0Thankfully, with a 12 member lab, it is actually not terri=
bly complex to handle, but I would definitely prefer a more comprehensive s=
olution. =C2=A0I don&#39;t doubt that the huge IO and seek demands we put o=
n these disks will cause more problems in the future.=C2=A0</div>

<div class=3D"im">
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex">
...<br>
<div>&gt;&gt; <a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune=
_my_XFS_filesystems_for_.3Csomething.3E" target=3D"_blank">http://xfs.org/i=
ndex.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E</=
a><br>



&gt;&gt;<br>
&gt;&gt; &quot;As of kernel 3.2.12, the default i/o scheduler, CFQ, will de=
feat much<br>
&gt;&gt; of the parallelization in XFS.&quot;<br>
</div>...<br>
<div>&gt;&gt; echo deadline &gt; /sys/block/sda/queue/scheduler<br>
&gt;&gt;<br>
&gt; Wow, this is huge, I can&#39;t believe I missed that. =C2=A0I have swi=
tched it to<br>
&gt; noop now as we use write caching. =C2=A0I have been trying to figure o=
ut for a<br>
&gt; while why I would keep getting timeouts when the NFS load was high. =
=C2=A0If you<br>
&gt; have any other suggestions for how I can improve performance, I would<=
br>
&gt; greatly appreciate it.<br>
<br>
</div>This may not fix NFS timeouts entirely but it should help. =C2=A0If t=
he NFS<br>
operations are seeking the disks to death you may still see timeouts.<br>
<div><br>
&gt;&gt; This one simple command line may help pretty dramatically, immedia=
tely,<br>
&gt;&gt; assuming your hardware array parameters aren&#39;t horribly wrong =
for your<br>
&gt;&gt; workloads, and your XFS alignment correctly matches the hardware g=
eometry.<br>
&gt;&gt;<br>
&gt; Great, thanks. =C2=A0Our workloads vary considerably as we are a biolo=
gy<br>
&gt; research lab, sometimes we do lots of seeks, other times we are almost=
<br>
&gt; maxing out read or write speed with massively parallel processes all<b=
r>
&gt; accessing the disk at the same time.<br>
<br>
</div>Do you use munin or something similar? =C2=A0Sample output:<br>
<a href=3D"http://demo.munin-monitoring.org/munin-monitoring.org/demo.munin=
-monitoring.org/index.html#disk" target=3D"_blank">http://demo.munin-monito=
ring.org/munin-monitoring.org/demo.munin-monitoring.org/index.html#disk</a>=
<br>



<br>
Project page:<br>
<a href=3D"http://munin-monitoring.org/" target=3D"_blank">http://munin-mon=
itoring.org/</a></blockquote><div><br></div></div><div>I have been using Ga=
nglia, but it doesn&#39;t have good NFS monitoring as far as I can tell. =
=C2=A0I will check out Munin, thanks for the advice.=C2=A0</div>

<div class=3D"im">
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex">
It also has an NFS module and many others. =C2=A0The storage oriented metri=
cs<br>
may be very helpful to you. =C2=A0You would install munin-node on the NFS<b=
r>
server and all compute nodes, and munin on a collector/web server. =C2=A0Th=
is<br>
will allow you to cross reference client and server NFS loads. =C2=A0You ca=
n<br>
then cross reference the time in your PBS logs to see which users were<br>
running which jobs when IO spikes occur on the NFS server. =C2=A0You&#39;ll=
 know<br>
exactly which workloads, or combination thereof, are causing IO spikes.<br>
<span><font color=3D"#888888"><br>
--<br>
Stan<br></font></span></blockquote><div><br></div></div><span class=3D"HOEn=
Zb"><font color=3D"#888888"><div>-Mike=C2=A0</div></font></span></div><br><=
/div></div>
</div><br></div>

--001a1134b048da095704ece5d418--


--===============3375961669763108226==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3375961669763108226==--
