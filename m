Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 826637F7B
	for <xfs@oss.sgi.com>; Sat,  7 Dec 2013 12:37:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E1D2AC002
	for <xfs@oss.sgi.com>; Sat,  7 Dec 2013 10:37:44 -0800 (PST)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
	[209.85.216.45]) by cuda.sgi.com with ESMTP id 6XhLyaF5Qwj4gYmE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 07 Dec 2013 10:37:25 -0800 (PST)
Received: by mail-qa0-f45.google.com with SMTP id o15so1512084qap.11
	for <xfs@oss.sgi.com>; Sat, 07 Dec 2013 10:37:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A302A9.9050509@hardwarefreak.com>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
	<52A03513.6030408@hardwarefreak.com>
	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>
	<CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>
	<52A191BA.20800@hardwarefreak.com>
	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>
	<52A302A9.9050509@hardwarefreak.com>
From: Mike Dacre <mike.dacre@gmail.com>
Date: Sat, 7 Dec 2013 10:36:41 -0800
Message-ID: <CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>
Subject: Re: Fwd: Sudden File System Corruption
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4828900843360924635=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4828900843360924635==
Content-Type: multipart/alternative; boundary=001a11c3ce549b4a2504ecf60d8d

--001a11c3ce549b4a2504ecf60d8d
Content-Type: text/plain; charset=UTF-8

On Sat, Dec 7, 2013 at 3:12 AM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 12/6/2013 4:14 PM, Mike Dacre wrote:
> > On Fri, Dec 6, 2013 at 12:58 AM, Stan Hoeppner <stan@hardwarefreak.com
> >wrote:
> ...
> > UUID=a58bf1db-0d64-4a2d-8e03-aad78dbebcbe /science                xfs
> > defaults,inode64          1 0
>
> Your RAID card has persistent write cache (BBWC) and we know it's
> enabled from tool your output.  By default XFS assumes BBWC is not
> present, and uses write barriers to ensure order/consistency.   Using
> barriers on top of BBWC will be detrimental to write performance, for a
> couple of reasons:
>
> 1.  Prevents the controller from optimizing writeback patterns
> 2.  A portion, or all of, the write cache is frequently flushed
>
> Add 'nobarrier' to your mount options to avoid this problem.  It should
> speed up many, if not all, write operations considerably, which will in
> turn decrease seek contention amongst jobs.  Currently your write cache
> isn't working nearly as well as it should, and in fact could be
> operating horribly.
>
> > On the slave nodes, I managed to reduce the demand on the disks by adding
> > the actimeo=60 mount option.  Prior to doing this I would sometimes see
> the
> > disk being negatively affected by enormous numbers of getattr requests.
> >  Here is the fstab mount on the nodes:
> >
> > 192.168.2.1:/science                      /science                nfs
> > defaults,vers=3,nofail,actimeo=60,bg,hard,intr,rw  0 0
>
> One minute attribute cache lifetime seems maybe a little high for a
> compute cluster.  But if you've had no ill effects and it squelched the
> getattr flood this is good.
>
> ...
> > Correct, I am not consciously aligning the XFS to the RAID geometry, I
> > actually didn't know that was possible.
>
> XFS alignment is not something to worry about in this case.
>
> ...
> >> So it's a small compute cluster using NFS over Infiniband for shared
> >> file access to a low performance RAID6 array.  The IO resource sharing
> >> is automatic.  But AFAIK there's no easy way to enforce IO quotas on
> >> users or processes, if at all.  You may simply not have sufficient IO to
> >> go around.  Let's ponder that.
> >
> > I have tried a few things to improve IO allocation.  BetterLinux have a
> > cgroup control suite that allow on-the-fly user-level IO adjustments,
> > however I found them to be quite cumbersome.
>
> This isn't going to work well because a tiny IO stream can seek the
> disks to death, such as a complex find command, ls -R, etc.  A single
> command such as these can generate thousands of seeks.  Shaping/limiting
> user IO won't affect this.
>
> ...
> >> Looking at the math, you currently have approximately 14*150=2100
> >> seeks/sec capability with 14x 7.2k RPM data spindles.  That's less than
> >> 100 seeks/sec per compute node, i.e. each node is getting about 2/3rd of
> >> the performance of a single SATA disk from this array.  This simply
> >> isn't sufficient for servicing a 23 node cluster, unless all workloads
> >> are compute bound, and none IO/seek bound.  Given the overload/crash
> >> that brought you to our attention, I'd say some of your workloads are
> >> obviously IO/seek bound.  I'd say you probably need more/faster disks.
> >> Or you need to identify which jobs are IO/seek heavy and schedule them
> >> so they're not running concurrently.
> >
> > Yes, this is a problem.  We sadly lack the resources to do much better
> than
> > this, we have recently been adding extra storage by just chaining
> together
> > USB3 drives with RAID and LVM... which is cumbersome and slow, but
> cheaper.
>
> USB disk is generally a recipe for disaster.  Plenty of horror stories
> on both this list and linux-raid regarding USB connected drives,
> enclosures, etc.  I pray you don't run into those problems.
>
> > My current solution is to be on the alert for high IO jobs, and to move
> > them to a specific torque queue that limits the number of concurrent
> jobs.
> >  This works, but I have not found a way to do it automatically.
> >  Thankfully, with a 12 member lab, it is actually not terribly complex to
> > handle, but I would definitely prefer a more comprehensive solution.  I
> > don't doubt that the huge IO and seek demands we put on these disks will
> > cause more problems in the future.
>
> Your LSI 9260 controller supports using SSDs for read/write flash cache.
>  LSI charges $279 for it.  It's called CacheCade Pro:
>
>
> http://www.lsi.com/products/raid-controllers/pages/megaraid-cachecade-pro-software.aspx
> .
>
>
> Connect two good quality fast SSDs to the controller, such as:
> http://www.newegg.com/Product/Product.aspx?Item=N82E16820147192
>
> Two SSDs, mirrored, to prevent cached writes from being lost if a single
> SSD fails.  You now have a ~90K IOPS, 128GB, 500MB/s low latency
> read/write cache in front of your RAID6 array.  This should go a long
> way toward eliminating your bottlenecks.  You can accomplish this for
> ~$550 assuming you have two backplane drive slots free for the SSDs.  If
> not, you add one of these for $279:
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816117207
>
> This is an Intel 24 port SAS expander, the same device as in your drive
> backplane.  SAS expanders can be daisy chained many deep.  You can drop
> it into a PCIe x4 or greater slot from which it only draws power--no
> data pins are connected.  Or if no slots are available you can mount it
> to the side wall of your rack server chassis and power it via the 4 pin
> Molex plug.  This requires a drill, brass or plastic standoffs, and DIY
> skills.  I use this option as it provides a solid mount for un/plugging
> the SAS cables, and being side mounted neither it nor the cables
> interfere with airflow.
>
> You'll plug the 9260-4i into one port of the Intel expander.  You'll
> need another SFF-8087 cable for this:
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16812652015
>
> You will plug your drive backplane cable into another of the 6 SFF-8087
> ports on the Intel.  Into a 3rd port you will plug an SFF-8087 breakout
> cable to give you 4 individual drive connections.  You will plug two of
> these into your two SSDs.
>
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816116097
>
> If you have no internal 2.5/3.5" drive brackets free for the SSDs and
> you'd prefer not to drill (more) holes in the chassis to directly mount
> them or a new cage for them, simply use some heavy duty Velcro squares,
> 2" is fine.
>
> Worst case scenario you're looking at less than $1000 to cure your IO
> bottlenecks, or at the very least mitigate them to a minor annoyance
> instead of a show stopper.  And if you free up some money for some
> external JBODs and drives in the future, you can route 2 of the unused
> SFF-8087 connectors of the Intel Expander out the back panel to attach
> expander JBOD enclosures, using one of these and 2 more of the 8087
> cables up above:
>
>
> http://www.ebay.com/itm/8-Port-SAS-SATA-6G-Dual-SFF-8088-mini-SAS-to-SFF-8087-PCIe-Adapter-w-LP-Bracket-/390508767029
>
> I'm sure someone makes a 3 port model but 10 minutes of searching didn't
> turn one up.  These panel adapters are application specific.  Most are
> made to be mounted in a disk enclosure where the HBA/RAID card is on the
> outside of the chassis, on the other end of the 8088 cable.  This two
> port model is designed to be inside a server chassis, where the HBA
> connects to the internal 8087 ports.  Think Ethernet x-over cable.
>
> The 9260-4i supports up to 128 drives.  This Intel expander and a panel
> connector allow you to get there with external JBODs.  The only caveat
> being that you're limited to "only" 4.8 GB/s to/from all the disks.
>
> --
> Stan
>

Hi Stan,

Thanks for the great advice, I think you are on to something there.  I will
look into doing this in the next week or so when I have more time.  I added
'nobarrier' to my mount options.

Thanks again, I will let you know how it goes after I have upgraded.

Best,

Mike

--001a11c3ce549b4a2504ecf60d8d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On S=
at, Dec 7, 2013 at 3:12 AM, Stan Hoeppner <span dir=3D"ltr">&lt;<a href=3D"=
mailto:stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.com</a>=
&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 12/6/2013 4:14 PM, Mike=
 Dacre wrote:<br>
&gt; On Fri, Dec 6, 2013 at 12:58 AM, Stan Hoeppner &lt;<a href=3D"mailto:s=
tan@hardwarefreak.com">stan@hardwarefreak.com</a>&gt;wrote:<br>
</div>...<br>
<div class=3D"im">&gt; UUID=3Da58bf1db-0d64-4a2d-8e03-aad78dbebcbe /science=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0xfs<br>
&gt; defaults,inode64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 0<br>
<br>
</div>Your RAID card has persistent write cache (BBWC) and we know it&#39;s=
<br>
enabled from tool your output. =C2=A0By default XFS assumes BBWC is not<br>
present, and uses write barriers to ensure order/consistency. =C2=A0 Using<=
br>
barriers on top of BBWC will be detrimental to write performance, for a<br>
couple of reasons:<br>
<br>
1. =C2=A0Prevents the controller from optimizing writeback patterns<br>
2. =C2=A0A portion, or all of, the write cache is frequently flushed<br>
<br>
Add &#39;nobarrier&#39; to your mount options to avoid this problem. =C2=A0=
It should<br>
speed up many, if not all, write operations considerably, which will in<br>
turn decrease seek contention amongst jobs. =C2=A0Currently your write cach=
e<br>
isn&#39;t working nearly as well as it should, and in fact could be<br>
operating horribly.<br>
<div class=3D"im"><br>
&gt; On the slave nodes, I managed to reduce the demand on the disks by add=
ing<br>
&gt; the actimeo=3D60 mount option. =C2=A0Prior to doing this I would somet=
imes see the<br>
&gt; disk being negatively affected by enormous numbers of getattr requests=
.<br>
&gt; =C2=A0Here is the fstab mount on the nodes:<br>
&gt;<br>
&gt; 192.168.2.1:/science =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0/science =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0nfs<br>
&gt; defaults,vers=3D3,nofail,actimeo=3D60,bg,hard,intr,rw =C2=A00 0<br>
<br>
</div>One minute attribute cache lifetime seems maybe a little high for a<b=
r>
compute cluster. =C2=A0But if you&#39;ve had no ill effects and it squelche=
d the<br>
getattr flood this is good.<br>
<br>
...<br>
<div class=3D"im">&gt; Correct, I am not consciously aligning the XFS to th=
e RAID geometry, I<br>
&gt; actually didn&#39;t know that was possible.<br>
<br>
</div>XFS alignment is not something to worry about in this case.<br>
<br>
...<br>
<div class=3D"im">&gt;&gt; So it&#39;s a small compute cluster using NFS ov=
er Infiniband for shared<br>
&gt;&gt; file access to a low performance RAID6 array. =C2=A0The IO resourc=
e sharing<br>
&gt;&gt; is automatic. =C2=A0But AFAIK there&#39;s no easy way to enforce I=
O quotas on<br>
&gt;&gt; users or processes, if at all. =C2=A0You may simply not have suffi=
cient IO to<br>
&gt;&gt; go around. =C2=A0Let&#39;s ponder that.<br>
&gt;<br>
&gt; I have tried a few things to improve IO allocation. =C2=A0BetterLinux =
have a<br>
&gt; cgroup control suite that allow on-the-fly user-level IO adjustments,<=
br>
&gt; however I found them to be quite cumbersome.<br>
<br>
</div>This isn&#39;t going to work well because a tiny IO stream can seek t=
he<br>
disks to death, such as a complex find command, ls -R, etc. =C2=A0A single<=
br>
command such as these can generate thousands of seeks. =C2=A0Shaping/limiti=
ng<br>
user IO won&#39;t affect this.<br>
<br>
...<br>
<div class=3D"im">&gt;&gt; Looking at the math, you currently have approxim=
ately 14*150=3D2100<br>
&gt;&gt; seeks/sec capability with 14x 7.2k RPM data spindles. =C2=A0That&#=
39;s less than<br>
&gt;&gt; 100 seeks/sec per compute node, i.e. each node is getting about 2/=
3rd of<br>
&gt;&gt; the performance of a single SATA disk from this array. =C2=A0This =
simply<br>
&gt;&gt; isn&#39;t sufficient for servicing a 23 node cluster, unless all w=
orkloads<br>
&gt;&gt; are compute bound, and none IO/seek bound. =C2=A0Given the overloa=
d/crash<br>
&gt;&gt; that brought you to our attention, I&#39;d say some of your worklo=
ads are<br>
&gt;&gt; obviously IO/seek bound. =C2=A0I&#39;d say you probably need more/=
faster disks.<br>
&gt;&gt; Or you need to identify which jobs are IO/seek heavy and schedule =
them<br>
&gt;&gt; so they&#39;re not running concurrently.<br>
&gt;<br>
&gt; Yes, this is a problem. =C2=A0We sadly lack the resources to do much b=
etter than<br>
&gt; this, we have recently been adding extra storage by just chaining toge=
ther<br>
&gt; USB3 drives with RAID and LVM... which is cumbersome and slow, but che=
aper.<br>
<br>
</div>USB disk is generally a recipe for disaster. =C2=A0Plenty of horror s=
tories<br>
on both this list and linux-raid regarding USB connected drives,<br>
enclosures, etc. =C2=A0I pray you don&#39;t run into those problems.<br>
<div class=3D"im"><br>
&gt; My current solution is to be on the alert for high IO jobs, and to mov=
e<br>
&gt; them to a specific torque queue that limits the number of concurrent j=
obs.<br>
&gt; =C2=A0This works, but I have not found a way to do it automatically.<b=
r>
&gt; =C2=A0Thankfully, with a 12 member lab, it is actually not terribly co=
mplex to<br>
&gt; handle, but I would definitely prefer a more comprehensive solution. =
=C2=A0I<br>
&gt; don&#39;t doubt that the huge IO and seek demands we put on these disk=
s will<br>
&gt; cause more problems in the future.<br>
<br>
</div>Your LSI 9260 controller supports using SSDs for read/write flash cac=
he.<br>
=C2=A0LSI charges $279 for it. =C2=A0It&#39;s called CacheCade Pro:<br>
<br>
<a href=3D"http://www.lsi.com/products/raid-controllers/pages/megaraid-cach=
ecade-pro-software.aspx" target=3D"_blank">http://www.lsi.com/products/raid=
-controllers/pages/megaraid-cachecade-pro-software.aspx</a>.<br>
<br>
<br>
Connect two good quality fast SSDs to the controller, such as:<br>
<a href=3D"http://www.newegg.com/Product/Product.aspx?Item=3DN82E1682014719=
2" target=3D"_blank">http://www.newegg.com/Product/Product.aspx?Item=3DN82E=
16820147192</a><br>
<br>
Two SSDs, mirrored, to prevent cached writes from being lost if a single<br=
>
SSD fails. =C2=A0You now have a ~90K IOPS, 128GB, 500MB/s low latency<br>
read/write cache in front of your RAID6 array. =C2=A0This should go a long<=
br>
way toward eliminating your bottlenecks. =C2=A0You can accomplish this for<=
br>
~$550 assuming you have two backplane drive slots free for the SSDs. =C2=A0=
If<br>
not, you add one of these for $279:<br>
<br>
<a href=3D"http://www.newegg.com/Product/Product.aspx?Item=3DN82E1681611720=
7" target=3D"_blank">http://www.newegg.com/Product/Product.aspx?Item=3DN82E=
16816117207</a><br>
<br>
This is an Intel 24 port SAS expander, the same device as in your drive<br>
backplane. =C2=A0SAS expanders can be daisy chained many deep. =C2=A0You ca=
n drop<br>
it into a PCIe x4 or greater slot from which it only draws power--no<br>
data pins are connected. =C2=A0Or if no slots are available you can mount i=
t<br>
to the side wall of your rack server chassis and power it via the 4 pin<br>
Molex plug. =C2=A0This requires a drill, brass or plastic standoffs, and DI=
Y<br>
skills. =C2=A0I use this option as it provides a solid mount for un/pluggin=
g<br>
the SAS cables, and being side mounted neither it nor the cables<br>
interfere with airflow.<br>
<br>
You&#39;ll plug the 9260-4i into one port of the Intel expander. =C2=A0You&=
#39;ll<br>
need another SFF-8087 cable for this:<br>
<br>
<a href=3D"http://www.newegg.com/Product/Product.aspx?Item=3DN82E1681265201=
5" target=3D"_blank">http://www.newegg.com/Product/Product.aspx?Item=3DN82E=
16812652015</a><br>
<br>
You will plug your drive backplane cable into another of the 6 SFF-8087<br>
ports on the Intel. =C2=A0Into a 3rd port you will plug an SFF-8087 breakou=
t<br>
cable to give you 4 individual drive connections. =C2=A0You will plug two o=
f<br>
these into your two SSDs.<br>
<br>
<a href=3D"http://www.newegg.com/Product/Product.aspx?Item=3DN82E1681611609=
7" target=3D"_blank">http://www.newegg.com/Product/Product.aspx?Item=3DN82E=
16816116097</a><br>
<br>
If you have no internal 2.5/3.5&quot; drive brackets free for the SSDs and<=
br>
you&#39;d prefer not to drill (more) holes in the chassis to directly mount=
<br>
them or a new cage for them, simply use some heavy duty Velcro squares,<br>
2&quot; is fine.<br>
<br>
Worst case scenario you&#39;re looking at less than $1000 to cure your IO<b=
r>
bottlenecks, or at the very least mitigate them to a minor annoyance<br>
instead of a show stopper. =C2=A0And if you free up some money for some<br>
external JBODs and drives in the future, you can route 2 of the unused<br>
SFF-8087 connectors of the Intel Expander out the back panel to attach<br>
expander JBOD enclosures, using one of these and 2 more of the 8087<br>
cables up above:<br>
<br>
<a href=3D"http://www.ebay.com/itm/8-Port-SAS-SATA-6G-Dual-SFF-8088-mini-SA=
S-to-SFF-8087-PCIe-Adapter-w-LP-Bracket-/390508767029" target=3D"_blank">ht=
tp://www.ebay.com/itm/8-Port-SAS-SATA-6G-Dual-SFF-8088-mini-SAS-to-SFF-8087=
-PCIe-Adapter-w-LP-Bracket-/390508767029</a><br>


<br>
I&#39;m sure someone makes a 3 port model but 10 minutes of searching didn&=
#39;t<br>
turn one up. =C2=A0These panel adapters are application specific. =C2=A0Mos=
t are<br>
made to be mounted in a disk enclosure where the HBA/RAID card is on the<br=
>
outside of the chassis, on the other end of the 8088 cable. =C2=A0This two<=
br>
port model is designed to be inside a server chassis, where the HBA<br>
connects to the internal 8087 ports. =C2=A0Think Ethernet x-over cable.<br>
<br>
The 9260-4i supports up to 128 drives. =C2=A0This Intel expander and a pane=
l<br>
connector allow you to get there with external JBODs. =C2=A0The only caveat=
<br>
being that you&#39;re limited to &quot;only&quot; 4.8 GB/s to/from all the =
disks.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Stan<br>
</font></span></blockquote></div><br></div><div class=3D"gmail_extra">Hi St=
an,</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Th=
anks for the great advice, I think you are on to something there. =C2=A0I w=
ill look into doing this in the next week or so when I have more time. =C2=
=A0I added &#39;nobarrier&#39; to my mount options.</div>

<div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Thanks agai=
n, I will let you know how it goes after I have upgraded.</div><div class=
=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Best,</div><div class=
=3D"gmail_extra">

<br></div><div class=3D"gmail_extra">Mike</div></div>

--001a11c3ce549b4a2504ecf60d8d--


--===============4828900843360924635==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4828900843360924635==--
