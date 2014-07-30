Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D39BB7F47
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 06:44:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71D83AC001
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 04:44:53 -0700 (PDT)
Received: from DUB004-OMC3S32.hotmail.com (dub004-omc3s32.hotmail.com
	[157.55.2.41]) by cuda.sgi.com with ESMTP id QIXVEicWvVvPyu3D
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Jul 2014 04:44:50 -0700 (PDT)
Message-ID: <DUB129-W56704A30090C101D9B0E94EEF90@phx.gbl>
From: "Frank ." <frank_1005@msn.com>
Subject: RE: Delaylog information enquiry
Date: Wed, 30 Jul 2014 13:44:49 +0200
In-Reply-To: <20140730081858.GN26465@dastard>
References: <DUB129-W7B2973281D7E749989D43EEF80@phx.gbl>,
	<20140729123815.GA13120@bfoster.bfoster>,
	<20140729234151.GJ26465@dastard>,
	<CAFLt3phu1kJUjFyP8-+zkRPEsiv8ue=c+W+Ym8PYS1zd3kHyzw@mail.gmail.com>,
	<20140730081858.GN26465@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4939744084344197920=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "neutrino8@gmail.com" <neutrino8@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4939744084344197920==
Content-Type: multipart/alternative;
	boundary="_0daa0c9c-fcd5-42c7-a254-2d6034097ab9_"

--_0daa0c9c-fcd5-42c7-a254-2d6034097ab9_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Indeed=2C I turned sync and wsync flags on. As excpected=2C I had terribly =
low performance (1MB/s for write operations). So I decided to turn them bac=
k off. (I got my 100 MB/s write throughput back).=20
I just wanted to reduce as much as possible unnecessary cache between my VM=
's and my physcal hard drives knowing that there are up to 8 write cache le=
vels.=20
I'm getting off the subject a bit but here is the list. This is only my con=
clusion. I don't know if I'm right.=20

- Guest page cache.
- Virtual disk drive write cache. (off KVM cache=3Ddirectsync)
- Host page cache. (off KVM cache=3Ddirectsync)
- GlusterFS cache. (off)
- NAS page cache. (?)
- XFS cache (filesystem).
- RAID controller write cache. (off)
- Physical hard drive write cache. (off)

The main difficulty is that I have to gather information from different sou=
rces (editors / constructors) to get an overview of the cache mechanisms. I=
 need to make sure our databases will not crash to any failure of one of th=
ose layers.

If you have any suggestions on where to find information or who to ask I wo=
uld be rather grateful.=20
But at least I had answers about the XFS part.=20
Thank you very much !

> Date: Wed=2C 30 Jul 2014 18:18:58 +1000
> From: david@fromorbit.com
> To: neutrino8@gmail.com
> CC: bfoster@redhat.com=3B frank_1005@msn.com=3B xfs@oss.sgi.com
> Subject: Re: Delaylog information enquiry
>=20
> On Wed=2C Jul 30=2C 2014 at 07:42:32AM +0200=2C Grozdan wrote:
> > On Wed=2C Jul 30=2C 2014 at 1:41 AM=2C Dave Chinner <david@fromorbit.co=
m> wrote:
> > > Note that this does not change file data behaviour. In this case you
> > > need to add the "sync" mount option=2C which forces all buffered IO t=
o
> > > be synchronous and so will be *very slow*. But if you've already
> > > turned off the BBWC on the RAID controller then your storage is
> > > already terribly slow and so you probably won't care about making
> > > performance even worse...
> >=20
> > Dave=2C excuse my ignorant questions
> >=20
> > I know the Linux kernel keeps data in cache up to 30 seconds before a
> > kernel daemon flushes it to disk=2C unless
> > the configured dirty ratio (which is 40% of RAM=2C iirc) is reached
>=20
> 10% of RAM=2C actually.
>=20
> > before these 30 seconds so the flush is done before it
> >=20
> > What I did is lower these 30 seconds to 5 seconds so every 5 seconds
> > data is flushed to disk (I've set the dirty_expire_centisecs to 500).
> > So=2C are there any drawbacks in doing this?
>=20
> Depends on your workload. For a desktop=2C you probably won't notice
> anything different. For a machine that creates lots of temporary
> files and then removes them (e.g. build machines) then it could
> crater performance completely because it causes writeback before the
> files are removed...
>=20
> > I mean=2C I don't care *that*
> > much for performance but I do want my dirty data to be on
> > storage in a reasonable amount of time. I looked at the various sync
> > mount options but they all are synchronous so it is my
> > impression they'll be slower than giving the kernel 5 seconds to keep
> > data and then flush it.
> >=20
> > From XFS perspective=2C I'd like to know if this is not recommended or
> > if it is? I know that with setting the above to 500 centisecs
> > means that there will be more writes to disk and potentially may
> > result in tear & wear=2C thus shortening the lifetime of the
> > storage
> >=20
> > This is a regular desktop system with a single Seagate Constellation
> > SATA disk so no RAID=2C LVM=2C thin provision or anything else
> >=20
> > What do you think? :)
>=20
> I don't think it really matters either way. I don't change
> the writeback time on my workstations=2C build machines or test
> machines=2C but I actually *increase* it on my laptops to save power
> by not writing to disk as often. So if you want a little more
> safety=2C then reducing the writeback timeout shouldn't have any
> significant affect on performance or wear unless you are doing
> something unusual....
>=20
> Cheers=2C
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
 		 	   		  =

--_0daa0c9c-fcd5-42c7-a254-2d6034097ab9_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>Indeed=2C I turned sync and wsyn=
c flags on. As excpected=2C I had terribly low performance (1MB/s for write=
 operations). So I decided to turn them back off. (I got my 100 MB/s write =
throughput back). <br>I just wanted to reduce as much as possible unnecessa=
ry cache between my VM's and my physcal hard drives knowing that there are =
up to 8 write cache levels. <br>I'm getting off the subject a bit but here =
is the list. This is only my conclusion. I don't know if I'm right. <br><br=
>- Guest page cache.<br>- Virtual disk drive write cache. (off KVM cache=3D=
directsync)<br>- Host page cache. (off KVM cache=3Ddirectsync)<br>- Gluster=
FS cache. (off)<br>- NAS page cache. (?)<br>- XFS cache (filesystem).<br>- =
RAID controller write cache. (off)<br>- Physical hard drive write cache. (o=
ff)<br><br>The main difficulty is that I have to gather information from di=
fferent sources (editors / constructors) to get an overview of the cache me=
chanisms. I need to make sure our databases will not crash to any failure o=
f one of those layers.<br><br>If you have any suggestions on where to find =
information or who to ask I would be rather grateful. <br>But at least I ha=
d answers about the XFS part. <br>Thank you very much !<br><br><div>&gt=3B =
Date: Wed=2C 30 Jul 2014 18:18:58 +1000<br>&gt=3B From: david@fromorbit.com=
<br>&gt=3B To: neutrino8@gmail.com<br>&gt=3B CC: bfoster@redhat.com=3B fran=
k_1005@msn.com=3B xfs@oss.sgi.com<br>&gt=3B Subject: Re: Delaylog informati=
on enquiry<br>&gt=3B <br>&gt=3B On Wed=2C Jul 30=2C 2014 at 07:42:32AM +020=
0=2C Grozdan wrote:<br>&gt=3B &gt=3B On Wed=2C Jul 30=2C 2014 at 1:41 AM=2C=
 Dave Chinner &lt=3Bdavid@fromorbit.com&gt=3B wrote:<br>&gt=3B &gt=3B &gt=
=3B Note that this does not change file data behaviour. In this case you<br=
>&gt=3B &gt=3B &gt=3B need to add the "sync" mount option=2C which forces a=
ll buffered IO to<br>&gt=3B &gt=3B &gt=3B be synchronous and so will be *ve=
ry slow*. But if you've already<br>&gt=3B &gt=3B &gt=3B turned off the BBWC=
 on the RAID controller then your storage is<br>&gt=3B &gt=3B &gt=3B alread=
y terribly slow and so you probably won't care about making<br>&gt=3B &gt=
=3B &gt=3B performance even worse...<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B Dav=
e=2C excuse my ignorant questions<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B I know=
 the Linux kernel keeps data in cache up to 30 seconds before a<br>&gt=3B &=
gt=3B kernel daemon flushes it to disk=2C unless<br>&gt=3B &gt=3B the confi=
gured dirty ratio (which is 40% of RAM=2C iirc) is reached<br>&gt=3B <br>&g=
t=3B 10% of RAM=2C actually.<br>&gt=3B <br>&gt=3B &gt=3B before these 30 se=
conds so the flush is done before it<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B Wha=
t I did is lower these 30 seconds to 5 seconds so every 5 seconds<br>&gt=3B=
 &gt=3B data is flushed to disk (I've set the dirty_expire_centisecs to 500=
).<br>&gt=3B &gt=3B So=2C are there any drawbacks in doing this?<br>&gt=3B =
<br>&gt=3B Depends on your workload. For a desktop=2C you probably won't no=
tice<br>&gt=3B anything different. For a machine that creates lots of tempo=
rary<br>&gt=3B files and then removes them (e.g. build machines) then it co=
uld<br>&gt=3B crater performance completely because it causes writeback bef=
ore the<br>&gt=3B files are removed...<br>&gt=3B <br>&gt=3B &gt=3B I mean=
=2C I don't care *that*<br>&gt=3B &gt=3B much for performance but I do want=
 my dirty data to be on<br>&gt=3B &gt=3B storage in a reasonable amount of =
time. I looked at the various sync<br>&gt=3B &gt=3B mount options but they =
all are synchronous so it is my<br>&gt=3B &gt=3B impression they'll be slow=
er than giving the kernel 5 seconds to keep<br>&gt=3B &gt=3B data and then =
flush it.<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B From XFS perspective=2C I'd li=
ke to know if this is not recommended or<br>&gt=3B &gt=3B if it is? I know =
that with setting the above to 500 centisecs<br>&gt=3B &gt=3B means that th=
ere will be more writes to disk and potentially may<br>&gt=3B &gt=3B result=
 in tear &amp=3B wear=2C thus shortening the lifetime of the<br>&gt=3B &gt=
=3B storage<br>&gt=3B &gt=3B <br>&gt=3B &gt=3B This is a regular desktop sy=
stem with a single Seagate Constellation<br>&gt=3B &gt=3B SATA disk so no R=
AID=2C LVM=2C thin provision or anything else<br>&gt=3B &gt=3B <br>&gt=3B &=
gt=3B What do you think? :)<br>&gt=3B <br>&gt=3B I don't think it really ma=
tters either way. I don't change<br>&gt=3B the writeback time on my worksta=
tions=2C build machines or test<br>&gt=3B machines=2C but I actually *incre=
ase* it on my laptops to save power<br>&gt=3B by not writing to disk as oft=
en. So if you want a little more<br>&gt=3B safety=2C then reducing the writ=
eback timeout shouldn't have any<br>&gt=3B significant affect on performanc=
e or wear unless you are doing<br>&gt=3B something unusual....<br>&gt=3B <b=
r>&gt=3B Cheers=2C<br>&gt=3B <br>&gt=3B Dave.<br>&gt=3B -- <br>&gt=3B Dave =
Chinner<br>&gt=3B david@fromorbit.com<br></div> 		 	   		  </div></body>
</html>=

--_0daa0c9c-fcd5-42c7-a254-2d6034097ab9_--


--===============4939744084344197920==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4939744084344197920==--
