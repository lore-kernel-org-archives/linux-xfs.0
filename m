Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BDTcES093785 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 08:29:38 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id i3j2s1CdAWIxPxBI for
	<xfs@oss.sgi.com>; Mon, 11 Jun 2012 06:29:37 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5BDTapW007935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 09:29:36 -0400
Received: from andromeda.usersys.redhat.com (vpn-9-5.rdu.redhat.com
	[10.11.9.5])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q5BDTXa6031020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 09:29:36 -0400
Date: Mon, 11 Jun 2012 10:29:32 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: block sizes > 4K ??  possible w/large page support?
Message-ID: <20120611132932.GA18432@andromeda.usersys.redhat.com>
References: <4FD5643F.5070801@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FD5643F.5070801@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

> Is this something being thought about??
> 
> More than one of my hard disks:
> 
> /boot:                 130 files in     103112 4K blocks:    793.6 blks/file
> /tmp:                 1401 files in     746715 4K blocks:    533.4 blks/file
> /var/cache:           1438 files in      87858 4K blocks:     61.5 blks/file
> /backups:              713 files in 2523985177 4K blocks: 3539951.6 blks/file
> /var:                 9038 files in     746715 4K blocks:     83.1 blks/file
> /var/cache/squid:      570 files in      90031 4K blocks:    158.4 blks/file
> /Media:              51893 files in 1691400956 4K blocks:  32594.5 blks/file
> /:                   37312 files in     506778 4K blocks:     14.0 blks/file
> /usr/share:         320805 files in  195425485 4K blocks:    609.6 blks/file
> /backups/Media:      50544 files in 1642550112 4K blocks:  32497.9 blks/file
> /usr:               116650 files in    1389380 4K blocks:     12.4 blks/file
> /Share:            1617995 files in  305269701 4K blocks:    189.1 blks/file
> /home:             5822174 files in  195412389 4K blocks:     34.0 blks/file
> 
> All but 2 could benefit from a 16K block size, and 3 of them could benefit
> from a 128K block size.  Wouldn't that benefit in  in freeing up some space
> both on disk and in memory?  Just a thought.

The maximum block size of a XFS filesystem is 64kiB. But in linux it's limited
to the PAGE_SIZE value. so, on x86 architectures, the maximum block size is
4kiB.
although it could benefit from a 16kiB page size, you'll need to be running an
operating system which supports this page size value.

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
