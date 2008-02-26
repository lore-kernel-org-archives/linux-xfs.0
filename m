Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Feb 2008 12:12:50 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1QKChDx021952
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 12:12:46 -0800
Received: from gv-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BEBC11EF9A7
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 12:13:10 -0800 (PST)
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.187]) by cuda.sgi.com with ESMTP id GVy1F0JIRFm6TWha for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 12:13:10 -0800 (PST)
Received: by gv-out-0910.google.com with SMTP id s4so782310gve.9
        for <xfs@oss.sgi.com>; Tue, 26 Feb 2008 12:13:09 -0800 (PST)
Message-ID: <2db2c6b80802261213v40490c3ex217ed2d3a077d7d4@mail.gmail.com>
Date: Tue, 26 Feb 2008 21:13:07 +0100
From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: Re: xfs I/O error
In-Reply-To: <20080225211055.GK29277@vestdata.no>
MIME-Version: 1.0
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
	 <20080224121722.GY29277@vestdata.no>
	 <2db2c6b80802250847m2d161f5n276026dae396d3cc@mail.gmail.com>
	 <20080225211055.GK29277@vestdata.no>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

2008/2/25, Ragnar Kj=F8rstad <xfs@ragnark.vestdata.no>:
>
> On Mon, Feb 25, 2008 at 05:47:12PM +0100, Rekrutacja119 wrote:
> > 2008/2/24, Ragnar Kj=F8rstad <xfs@ragnark.vestdata.no>:
> > >
> > > On Sat, Feb 23, 2008 at 10:46:52PM +0100, Rekrutacja119 wrote:
> > > > the easiest solution would be to just ignore errors, and if not,
> then to
> > > > somehow force xfs to mark them as bad sectors
> > >
> > > If you really wanted to you could probably use dm to map your bad
> > > sectors to another device.
> >
> > what do you mean by that? how to do it ?
>
> dm is the linux device mapper. It is used by LVM to map virtual blocks
> from logical volumes to physical blocks on logical volumes, but you can
> also create your custom remapping table to do other things.
>
> I don't know the exact dmsetup command, but you should be able to find
> that in the dm documentation or ask on the dm mailinglist.
>
> http://sources.redhat.com/dm/



but i suppose i can do it like Eric told me - mount it read only. effects
would be the same - i will have acess to everything that is readable, and i
wont even have to copy all the stuff into the same device (i can copy half
of the dirs to one, and other half to others)

the read-only advice was very good and thank you very much eric, it helped
me a lot.


[[HTML alternate version deleted]]
