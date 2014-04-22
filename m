Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED8AA7F51
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 07:43:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E3698F8064
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 05:43:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id orLu55j87Qsj5RMg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 05:43:30 -0700 (PDT)
Message-ID: <535663CB.5080309@oracle.com>
Date: Tue, 22 Apr 2014 20:42:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: bulletfproof xfs_qm_scall_trunc_qfiles()
References: <53558354.5040309@redhat.com>
	<20140422062736.GA31337@infradead.org>
In-Reply-To: <20140422062736.GA31337@infradead.org>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>


On 04/22 2014 14:27 PM, Christoph Hellwig wrote:
> On Mon, Apr 21, 2014 at 03:45:08PM -0500, Eric Sandeen wrote:
>> Coverity noticed that if we sent junk into
>> xfs_qm_scall_trunc_qfiles(), we could get back an
>> uninitialized error value.  So sanitize the flags we
>> will accept, and initialize error anyway for good measure.
>>
>> (This bug may have been introduced via c61a9e39).

Indeed, my mistake.

>>
>> Should resolve Coverity CID 1163872.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me too.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
