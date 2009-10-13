Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DNZMUF160480 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 18:35:22 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 01/14] repair: merge scanfunc_bno and scanfunc_cnt
Date: Tue, 13 Oct 2009 18:36:47 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADA4@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091013221335.GA30832@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On , Christoph Hellwig wrote:
> On Mon, Oct 12, 2009 at 11:53:00AM -0500, Eric Sandeen wrote:
>> 
>> Should we explicitly test that this is either XFS_ABTC_MAGIC or
>> XFS_ABTB_MAGIC here to avoid any programming-error
>> type problems?
> 
> We really only have two freespace btrees.  But I'll add an assert
> just to be sure.
> 
>>> -				else  {
>>> +					break;
>>> +				case XR_E_FREE1:
>>> +					/*
>>> +					 * no warning messages -- we'll catch
>>> +					 * FREE1 blocks later
>>> +					 */
>>> +					if (magic != XFS_ABTB_MAGIC) {
>> 
>> Why not make this explicitly "if (magic == XFS_ABTC_MAGIC)" - I guess it seems potentially
>> more future-proof to me though I don't suppose we'll ever get a new type here.  :)
>> The positive test seems clearer to me but *shrug*.
> 
> Ok, changed.

With changes as described, looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
