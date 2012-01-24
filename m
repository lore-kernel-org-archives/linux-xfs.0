Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O57bjr192596 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 23:07:37 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 2K6aGtNd9xSELC2g for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 21:07:36 -0800 (PST)
Message-ID: <4F1E3C97.1010503@sandeen.net>
Date: Mon, 23 Jan 2012 23:07:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: check for size parsing errors in xfs_quota
References: <4F1D9989.8060808@redhat.com> <20120123195922.GA2366@infradead.org>
In-Reply-To: <20120123195922.GA2366@infradead.org>
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
Cc: James Lawrie <james@jdlawrie.co.uk>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/23/12 1:59 PM, Christoph Hellwig wrote:
> On Mon, Jan 23, 2012 at 11:31:53AM -0600, Eric Sandeen wrote:
>> Doing something like 
>>
>> # xfs_quota -x -c 'limit -u bhard=1.2g ...
>>
>> will cause cvtnum to fail and return a value of -1LL (because it
>> cannot parse the decimal), but the quota caller doesn't check
>> for this error value, casts it to U64, shifts right, and we end
>> up with an answer of 16 petabytes rather than erroring out.
>> Fix this.
> 
> Can you add a test case for it, please?

sure... I have quite a backlog of tests I need to get pushed to git :(

Is that an ack for the patch, though? :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
