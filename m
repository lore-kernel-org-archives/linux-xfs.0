Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB4F97CA0
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2016 22:30:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51757AC001
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2016 20:30:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1bHyUBcKKRQu6NSI for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2016 20:30:07 -0700 (PDT)
Received: from Liberator.local (204-195-32-108.wavecable.com [204.195.32.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 073D6EE6
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2016 22:30:06 -0500 (CDT)
Subject: Re: [PATCH 009/119] xfs: convert list of extents to free into a
	regular list
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612632997.12839.18026491074892368053.stgit@birch.djwong.org>
	<20160617115930.GH19042@infradead.org>
	<20160618201509.GA5042@birch.djwong.org>
	<20160621005712.GN26977@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e34e300d-6e56-8617-4ba6-ef034bfc2e9f@sandeen.net>
Date: Sun, 17 Jul 2016 20:30:04 -0700
MIME-Version: 1.0
In-Reply-To: <20160621005712.GN26977@dastard>
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
To: xfs@oss.sgi.com

On 6/20/16 5:57 PM, Dave Chinner wrote:
> On Sat, Jun 18, 2016 at 01:15:10PM -0700, Darrick J. Wong wrote:
>> On Fri, Jun 17, 2016 at 04:59:30AM -0700, Christoph Hellwig wrote:
>>>>  {
>>>> +	struct xfs_bmap_free_item	*new;		/* new element */
>>>>  #ifdef DEBUG
>>>>  	xfs_agnumber_t		agno;
>>>>  	xfs_agblock_t		agbno;
>>>> @@ -597,17 +595,7 @@ xfs_bmap_add_free(
>>>>  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
>>>>  	new->xbfi_startblock = bno;
>>>>  	new->xbfi_blockcount = (xfs_extlen_t)len;
>>>> +	list_add(&new->xbfi_list, &flist->xbf_flist);
>>>>  	flist->xbf_count++;
>>>
>>> Please kill xbf_count while you're at it, it's entirely superflous.
>>
>> The deferred ops conversion patch kills this off by moving the whole
>> "defer an op to the next transaction by logging redo items" logic
>> into a separate file and mechanism.
>>
>> This patch is just a cleanup to reduce some of the open coded list ugliness
>> before starting on the rmap stuff.  Once the deferred ops code lands, all
>> three of these functions go away.
> 
> Ok, so because all these functions go away, I'll take this patch now
> without the suggested cleanups so that you don't have to rework it.
> 
> ....
> 
>>>> +	list_sort((*tp)->t_mountp, &flist->xbf_flist, xfs_bmap_free_list_cmp);
>>>
>>> Can you add a comment on why we are sorting the list?
>>
>> We sort the list so that we process the freed extents in AG order to
>> avoid deadlocking.
>>
>> I'll add a comment to the deferred ops code if there isn't one already.
> 
> This seems best - add the clean up to the later patches rather than
> have to rework lots of patches because of minor mods to early
> patches...

I'm woefully late to the game here, but adding comments later doesn't
help a future reader of commits like this, when neither the commit log
nor the patch contents explains things like why it's being sorted.

> then use list_sort to sort it prior to processing.

The changelog should say *why* a thing was done, not just *what* was
done; the diff already tells us that, right...

</soapbox>

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
