Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6184E7F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 12:15:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2A35AC001
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 10:15:10 -0700 (PDT)
Received: from mx141.netapp.com (mx141.netapp.com [216.240.21.12]) by
	cuda.sgi.com with ESMTP id Na9qHeOLuweJKS12 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 10:15:08 -0700 (PDT)
Message-ID: <5512ED19.4060902@Netapp.com>
Date: Wed, 25 Mar 2015 13:15:05 -0400
From: Anna Schumaker <Anna.Schumaker@netapp.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
References: <20150318205554.GA10716@fieldses.org> <5509E824.6070006@Netapp.com>
	<20150318211144.GB10716@fieldses.org>
	<OFB111A6D8.016B8BD5-ON88257E0D.001D174D-88257E0D.005268D6@us.ibm.com>
	<20150319153627.GA20852@fieldses.org>
	<OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
	<20150320151718.GD2036@fieldses.org>
	<20150320162303.GA18786@infradead.org>
	<20150320182621.GH2036@fieldses.org>
	<CAFX2JfkybBPcqD6A8r-jOkPnkL26=NEuK3zhA6TLn-DVam+kfQ@mail.gmail.com>
	<20150324174916.GA28906@infradead.org>
In-Reply-To: <20150324174916.GA28906@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Marc Eshel <eshel@us.ibm.com>, linux-nfs-owner@vger.kernel.org, xfs@oss.sgi.com

On 03/24/2015 01:49 PM, Christoph Hellwig wrote:
> On Tue, Mar 24, 2015 at 08:43:31AM -0400, Anna Schumaker wrote:
>>> I don't know, and don't have profiles.  I'll either try to reproduce or
>>> wait till Anna's back from vacation.
>>
>> I'm using whatever functions NFSD already uses for reading files,
>> which I expect go through the VFS.  Is there a flag that controls
>> cache behavior?
> 
> There's the O_DIRECT flag, but that's not what I mean.  If you just
> wrote to it it's a cached read, if you did unmount the filesystem after
> writing, or did an echo to /proc/sys/vm/drop_caches you get uncached
> read behavior.

Oh, I'm doing uncached reads for my tests.  I'm collecting updated numbers now!

Anna
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
