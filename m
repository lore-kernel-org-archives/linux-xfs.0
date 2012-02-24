Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OEvkH5055949 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 08:57:46 -0600
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	4WrNsM0EMyC1EDaW (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Feb 2012 06:57:44 -0800 (PST)
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[192.168.34.188])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.77) (envelope-from <mw@dermichi.com>) id 1S0wac-00081n-U3
	for xfs@oss.sgi.com; Fri, 24 Feb 2012 15:57:42 +0100
Message-ID: <4F47A564.8090204@dermichi.com>
Date: Fri, 24 Feb 2012 15:57:40 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com>
In-Reply-To: <4F478818.4050803@cape-horn-eng.com>
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

Hi Richard!
> 
> mkfs.xfs -i size=512 -d su=stripe_size,sw=28 -L Backup_2 /dev/sdX1
> 
This suggests that you plan to create partitions like /dev/sdX1 on the
RAID-6. If you really do (which is not a good idea IMHO because it buys
you nothing) you will have to be extra-careful to not mess up the stripe
alignment. I think the better option is to create the XFS directly on
/dev/sdX without partitions.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
