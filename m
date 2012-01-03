Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q03FmvCG034841 for <xfs@oss.sgi.com>; Tue, 3 Jan 2012 09:48:57 -0600
Message-ID: <4F032365.30500@sgi.com>
Date: Tue, 03 Jan 2012 09:48:53 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 v2] xfs: log all dirty inodes in xfs_fs_sync_fs
References: <20111218154936.GA17626@infradead.org>	<20111218155015.GC17626@infradead.org>	<20111220200841.GA2788@infradead.org>	<20111223214703.GW29840@sgi.com>
	<20111226121302.GE12731@dastard>	<20111229154207.GK21646@sgi.com>
	<20111229214441.GI12731@dastard>
In-Reply-To: <20111229214441.GI12731@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Paul Anderson <pha@umich.edu>, Ben Myers <bpm@sgi.com>, Sean Thomas Caron <scaron@umich.edu>, xfs@oss.sgi.com

On 12/29/11 15:44, Dave Chinner wrote:
> On Thu, Dec 29, 2011 at 09:42:07AM -0600, Ben Myers wrote:
>> Hi Dave,
>>
>> On Mon, Dec 26, 2011 at 11:13:02PM +1100, Dave Chinner wrote:
>>> On Fri, Dec 23, 2011 at 03:47:03PM -0600, Ben Myers wrote:
>>>>
>>>> Reviewed-by: Ben Myers<bpm@sgi.com>
>>>>
>>>> Mark also reviewed this.
>>>>
>>>> Reviewed-by: Mark Tinguely<tinguely@sgi.com>
>>>
>>> Just a process note here: if Mark reviewed the code and is happy
>>> with it, then he needs to send his reviewed-by tag himself. If he's
>>> got concerns, then he needs to discuss them on the list with the
>>> patch author, not just in private with you. If a person's questions
>>> are not posted to the mailing list or posted by proxy and they
>>> didn't aprticipate in discussions on the list, then there is no
>>> evidence that the person ever reviewed the patch. Hence the tag has
>>> no value because it is not verifiable.
>>
>> I tend to agree that it is important to discuss things openly on the
>> list.  Will make an effort to do more of this.
>>
>>> More importantly, tags are a semi-formal statement that a set of
>>> actions has been taken by that person - see
>>> Documentation/SubmittingPatches for the actions different tags
>>> imply. Hence it is important the actions they imply are verifiable,
>>> and it also reinforces the fact that they only have value when they
>>> are issued by the email address (or a known alias) in the tag....
>>
>> I don't see anything in SubmittingPatches that says the address on the
>>  From line not matching a tag is a dealbreaker, and I think that we
>> should give credit where it is due.  Mark did some work to review and
>> understand this code in addition to his testing.
>
> But credit is not what the Reviewed-by tag means - it's a statement
> of fact about actions performed by the reviewer. A partial review or
> partaking in part of a review does not mean a person can put a
> "reviewed-by" tag on a commit. An Acked-by my be appropriate in that
> case (though I see them a worthless by their very nature), but
> reviewed-by tags are not for "giving credit" to other people that
> may have helped you.
>
> Further, keep in mind that I've only ever seen 2 emails from Mark,
> so I have no idea who he is or what his capabilities are, so I do
> not yet know how much to trust his reviews or testing. Until I've
> spend some time interacting with him directly, I won't be able to
> form those opinions, and so such tags start at the lower end of
> value. They have even less value when they don't come from him and
> he hasn't commented where I can see it.
>
>> I have him a call and
>> asked him if I could add a 'Reviewed-by' to his 'Tested-by' because I
>> was suprised he didn't... Next time I'll ask him to send it himself.
>
> So, perhaps he didn't consider what he did met all the criteria of a
> reviewed-by tag? See what I mean about tags being worthless when sent
> by proxy?
>
>> I'd like to point out that plenty of the conversation surrounding this
>> pair of patches seems not to have made it to the list either.
>
> Happens all the time, especially on #xfs. The difference is, though,
> that such conversations are not "reviews" or result in one person
> sending reviewed-by tags for all the participants in the
> conversation....
>
> Cheers,
>
> Dave.

Thank-you for the feedback. There are several good points made in this 
thread.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
