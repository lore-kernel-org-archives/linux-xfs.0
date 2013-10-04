Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF3977F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 06:16:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6242BAC006
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 04:16:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id MgETfsaxIvDXFLme (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Oct 2013 04:16:46 -0700 (PDT)
Date: Fri, 4 Oct 2013 04:16:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xattr limits
Message-ID: <20131004111640.GA22948@infradead.org>
References: <C1F9D079-3D19-4A39-872A-0CAF8EA3866F@gmail.com>
	<524E59FC.9030903@dachary.org>
	<31BF914D-D406-428E-8671-0005901E10E6@inktank.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <31BF914D-D406-428E-8671-0005901E10E6@inktank.com>
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
To: David Zafman <david.zafman@inktank.com>
Cc: Loic Dachary <loic@dachary.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, xfs@oss.sgi.com

Might be good to send the crash report to the XFS list..

On Thu, Oct 03, 2013 at 11:54:29PM -0700, David Zafman wrote:
> 
> Here is the test script:
> 


> 
> David Zafman
> Senior Developer
> http://www.inktank.com
> 
> 
> 
> 
> On Oct 3, 2013, at 11:02 PM, Loic Dachary <loic@dachary.org> wrote:
> 
> > Hi David,
> > 
> > Would you mind attaching the script to the mail for completness ? It's a useful thing to have :-)
> > 
> > Cheers
> > 
> > On 04/10/2013 01:21, David Zafman wrote:
> >> 
> >> I want to record with the ceph-devel archive results from testing limits of xattrs for Linux filesystems used with Ceph.
> >> 
> >> Script that creates xattrs with name user.test1, user.test2, ?. on a single file
> >> 3.10 linux kernel
> >> 
> >> ext4  
> >> value bytes       number of entries
> >>    1               148
> >>   16             103
> >>  256          14
> >>  512            7
> >>  1024         3
> >> 4036          1 
> >> Beyond this immediately get ENOSPC
> >> 
> >> btrfs    
> >> value bytes       number of entries
> >> 8       		 10k
> >> 16       		10k
> >> 32        		 10k
> >> 64        		 10k
> >> 128     		 10k
> >> 256       		 10k
> >> 512        		10k  slow but worked 1,000,000 got completely hung for minutes at a time during removal strace showed no forward progress
> >> 1024        	 10k
> >> 2048        	 10k
> >> 3096          	 10k
> >> Beyond this you start getting ENOSPC after fewer entries
> >> 
> >> xfs (limit entries due to xfs crash with 10k entries)
> >> value bytes       number of entries
> >> 1   			1k
> >> 8   			 1k
> >> 16   			 1k
> >> 32  			 1k
> >> 64   		        1k
> >> 128   		 1k
> >> 256 			1k
> >> 512  		 1k
> >> 1024 		1k
> >> 2048  		 1k
> >> 4096   		 1k
> >> 8192   		 1k
> >> 16384   		 1k
> >> 32768   		 1k
> >> 65536   		 1k
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> > 
> > -- 
> > Lo?c Dachary, Artisan Logiciel Libre
> > All that is necessary for the triumph of evil is that good people do nothing.
> > 
> 

---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
