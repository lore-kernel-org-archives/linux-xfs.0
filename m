Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57BF47CE0
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 08:11:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BA7F304048
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 06:11:32 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id f7THd41FO8Rt1TAI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2016 06:11:30 -0700 (PDT)
Date: Mon, 8 Aug 2016 06:11:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160808131126.GA14464@infradead.org>
References: <20160729022152.GZ16044@dastard>
	<CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
	<20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
	<20160802002144.GL16044@dastard>
	<1470335997.8908.128.camel@hpe.com>
	<20160805112739.GG16044@dastard>
	<CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
	<20160808092655.GA29128@quack2.suse.cz>
	<CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CS1PR84MB0119ACB424699154BDA197B28E1B0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
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
To: "Boylston, Brian" <brian.boylston@hpe.com>
Cc: Jan Kara <jack@suse.cz>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Mon, Aug 08, 2016 at 12:30:18PM +0000, Boylston, Brian wrote:
> I used NVML 1.1 for the measurements.  In this version and with the hardware
> that I used, the pmem_persist() flow is:

Please don't use crap like NVML, given that the people behind it don't
seem to understand persistency at all.

> Perhaps you mean pmem_msync() here?  pmem_msync() calls msync(), but
> pmem_persist() does not.

pmem_persist is misnamed then, don't use it.

> > At which point
> > you've lost most of the advantages using movnt. Ross researches into
> > possibilities of allowing more efficient userspace implementation but
> > currently there are none.
> 
> Apart from the current performance discussion, if the metadata for a file
> is already established (file created, space allocated by explicit writes(),
> and everything synced), then if I map it and do pmem_memcpy_persist(),
> are there any "ongoing" metadata updates that would need to be flushed
> (besides timestamps)?

Yes.  For example because every write might mean a new space allocating
if using reflinks or a COW file system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
