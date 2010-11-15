Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFLYgeQ179191 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 15:34:42 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99ADAAC002
	for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 13:36:14 -0800 (PST)
Message-ID: <4CE1A7CE.7040905@sgi.com>
Date: Mon, 15 Nov 2010 15:36:14 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/9] xfsrestore: cleanup node allocation
References: <20101105163500.747192954@sgi.com>	
	<20101105163643.987306372@sgi.com>
	<1289853509.2199.224.camel@doink>
In-Reply-To: <1289853509.2199.224.camel@doink>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On 11/15/2010 02:38 PM, Alex Elder wrote:
> On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
>> plain text document attachment (node_alloc_cleanup)
>> Simplify the node allocation code. The current code takes some
>> number of nodes from a new segment and links them into the
>> freelist whenever the freelist is depleted. There's no reason
>> to put the new nodes on the freelist, we can just allocate the
>> next available new node as needed. This also saves a trip through
>> win_map/win_unmap if there are no nodes on the freelist (the
>> common case).
>
> Prior to your change, a node allocated off the "virgin"
> segment got zeroed before it gets returned for use. Your
> change eliminates that.  Is that OK?

There's a wrapper function, Node_alloc, through which
all callers allocate nodes. Node_alloc initializes each
field. So this is okay.

>
> You also dropped a few TREE_DEBUG messages.  Were they
> not useful?  (Just curious.)

I did not find them useful (though probably should have
mentioned it in the commit message.)

Bill

>
> Otherwise looks good.
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
