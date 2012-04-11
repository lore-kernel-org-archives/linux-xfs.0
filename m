Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BKAV5H106514 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 15:10:31 -0500
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37]) by cuda.sgi.com
	with ESMTP id zDggOcf3WsgGdzJC (version=TLSv1 cipher=RC4-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 13:10:30 -0700 (PDT)
Message-ID: <4F85E524.1090107@netapp.com>
Date: Wed, 11 Apr 2012 16:10:12 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
MIME-Version: 1.0
Subject: Re: [PATCH] 273: don't delete everything if $SCRATCH_MNT isn't set
References: <4F832C25.3080408@netapp.com> <20120409214445.GJ18323@dastard>
	<20120411200433.GE28816@infradead.org>
In-Reply-To: <20120411200433.GE28816@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 04/11/12 16:04, Christoph Hellwig wrote:

> On Tue, Apr 10, 2012 at 07:44:45AM +1000, Dave Chinner wrote:
>> On Mon, Apr 09, 2012 at 02:36:21PM -0400, Bryan Schumaker wrote:
>>> The cleanup function is trapped before _require_scratch() is called, and
>>> then expands "rm -rf $SCRATCH_MNT/*" to "rm -rf /*"
>>
>> It doesn't need to clean up the scratch device - tests need to mkfs
>> it first before using it, so just remove the $tmp* files. The sae
>> fix is needed for tests 274 and 275.
> 
> Given his address I assume Bryan might test on NFS, which has funky
> semantics for the scratch device.
> 
> Is that true Bryan?  I really need to dive back into how we handle NFS
> in this respect to have a good judgement on this patch.
> 


Yeah, I'm testing on NFS (I guess the netapp address is a bit of a giveaway...).  I don't think this test runs on NFS, but if the scratch variables are unset then it'll still delete the root directory of the NFS client.

- Bryan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
