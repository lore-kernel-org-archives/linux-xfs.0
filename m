Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13A4D7F55
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 04:58:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96DE6AC006
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 02:58:03 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id iGJYUJJDJBuM62BC for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 02:57:58 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS filesystem corruption
Date: Tue, 12 Mar 2013 10:57:51 +0100
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<CAPcwv6wK7m5UbJZass5690N5UpXEMV+HVzJa5mn9KWtT9UPQ9w@mail.gmail.com>
	<20130307232214.GY23616@dastard>
	(sfid-20130308_003651_720717_B9D6B992)
In-Reply-To: <20130307232214.GY23616@dastard>
MIME-Version: 1.0
Message-Id: <201303121057.52092.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: Ric Wheeler <rwheeler@redhat.com>, Julien FERRERO <jferrero06@gmail.com>

Am Freitag, 8. M=E4rz 2013 schrieb Dave Chinner:
> On Thu, Mar 07, 2013 at 02:15:31PM +0100, Julien FERRERO wrote:
> > > We actually test brutal "Power off" for xfs, ext4 and other file
> > > systems. If your storage is configured properly and you have
> > > barriers enabled, they all pass without corruption.
> > > =

> > > What hardware raid cards can do is to hide a volatile write cache.
> > > Either on the raid HBA itself or, even worse, on the backend disks
> > > behind the card. S-ata disks tend to default to write cache enabled
> > > and need to be checked especially careful (sas drives tend to be
> > > write cache disabled by default).
> >
> > =

> >
> > Write cache is supposed to be disabled on the H/W RAID (according to
> > hdparm) and barrier are correctly enabled since xfs does not report
> > any warning at mount.
> >
> > =

> >
> > The odd thing is we never see this with kernel 2.6.18 where barriers
> > weren't yet available.
> =

> Yes they were. XFS had barrier support added in 2.6.15.

I thought this was 2.6.16? Or was that the kernel where it became usable du=
e =

to the generic write barrier part being merged while the XFS one was ready =

earlier?

I still remember the XFS filesystem crashes I had back then that went away =

with disabling the write cache of the drive in my ThinkPad T42 back then an=
d =

where solved with 2.6.17, whereas 2.6.17.7 solved a directory corruption =

issue introduced with 2.6.17. Thus I always recommended at least 2.6.17.7 i=
n =

case of write barrier usage with XFS.

Thanks,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
