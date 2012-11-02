Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2EXK0x138926 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 09:33:20 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yuWZZCMnVx0dgrpO for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 07:35:12 -0700 (PDT)
Message-ID: <5093DA1F.5080305@sandeen.net>
Date: Fri, 02 Nov 2012 09:35:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs_logprint: Handle continued inode transactions
References: <5092A1DE.10609@redhat.com> <5092A430.8080109@redhat.com>
	<20121102130425.GB12578@infradead.org>
In-Reply-To: <20121102130425.GB12578@infradead.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 11/2/12 8:04 AM, Christoph Hellwig wrote:
> On Thu, Nov 01, 2012 at 11:32:48AM -0500, Eric Sandeen wrote:
>>
>> Tested by running xfs_logprint of TEST_DEV in xfsprogs
>> after sequential tests; without this change it gets off
>> in the weeds eventually; with this fix, it lasts longer,
>> until it hits some other yet-unfixed logprint bug...
> 
> Add this testcase to xfstests, please.

well, "this" isn't really a testcase; it's just running logprint
after every test.  And in some cases, esp. if the log has wrapped,
that just fails outright due to unrelated problems.

TBH I'm not sure how to generate a testcase for just this issue.
Any ideas?

>>  int
>> -xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops)
>> +xlog_print_trans_inode(xfs_caddr_t *ptr, int len, int *i, int num_ops, int continued)
> 
> Shouldn't this be a bool?

sure

>>  	xlog_print_op_header(op_head, i, &ptr);
>> +	continued = (XLOG_SET(op_head->oh_flags, XLOG_WAS_CONT_TRANS) ||
>> +		     XLOG_SET(op_head->oh_flags, XLOG_CONTINUE_TRANS));
> 
> I'd also really love to see another cleanup patch to kill the
> XLOG_SET macro.  The XLOG_ flags are true flags so they can be replaced
> by a simple op_head->oh_flags & XLOG_FLAG.

hm, yeah, that is odd.

                if (*last_was_partial_copy)
                        ophdr->oh_flags |= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);

whereas XLOG_SET tests for one and only one.

-Eric

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
