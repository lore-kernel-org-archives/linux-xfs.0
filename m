Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4CADA7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 18:11:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CB26304039
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:11:52 -0700 (PDT)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [217.188.63.246]) by
	cuda.sgi.com with ESMTP id HyOVEBDtS5gWlwKQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jul 2013 16:11:50 -0700 (PDT)
Date: Tue, 16 Jul 2013 01:11:45 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: XFS errors on 3TB HDD that is identified of size 2TB only
Message-ID: <20130715231145.GA5738@citd.de>
References: <trinity-f93ee630-12d7-49a7-a5ac-9038d9cfa0b0-1373789144486@3capp-webde-bs29>
	<22762971.1368.1373817100242.JavaMail.root@benjamin.baylink.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <22762971.1368.1373817100242.JavaMail.root@benjamin.baylink.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On 14.07.2013 11:51, Jay Ashworth wrote:
> ----- Original Message -----
> > From: "Thomas Schneider" <c.monty@web.de>
> 
> > On my new HDD WD30EZRX I created a GPT partition table and formatted
> > it with XFS.
> > Then I put some data (approx. 2.4TB) on that new partition.
> > 
> > However, after restarting the system the disk is identified of size
> > 2TB only.
> > knoppix@Microknoppix:~$ sudo fdisk -l
> 
> Stop!  Wait a minute!  Stop it, boy!
> 
> (Sorry; Meat Loaf flashback.  :-)
> 
> You're looking at that partition table with fdisk, *which doesn't understand
> GPT partition tables*; it's amazing it didn't complain louder.

It does. At least the version i got does:

...
WARNING: The size of this disk is 3.0 TB (3000592982016 bytes).
DOS partition table format can not be used on drives for volumes
larger than (2199023255040 bytes) for 512-byte sectors. Use parted(1) 
and GUID partition table format (GPT).
...

And that's not even the most recent version:
fdisk -v
fdisk (util-linux 2.20.1)

But in the OP-Case the kernel appeared to reported the disc as 2TB, 
which could be seen in the fdisk output.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
