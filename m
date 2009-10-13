Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DMC693156368 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 17:12:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4CE589015B
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:13:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IFnsgNE9B6GvSFTn for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 15:13:35 -0700 (PDT)
Date: Tue, 13 Oct 2009 18:13:35 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/14] repair: merge scanfunc_bno and scanfunc_cnt
Message-ID: <20091013221335.GA30832@infradead.org>
References: <20090902175531.469184575@bombadil.infradead.org>
	<20090902175839.915684396@bombadil.infradead.org>
	<4AD35EEC.4080707@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AD35EEC.4080707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 12, 2009 at 11:53:00AM -0500, Eric Sandeen wrote:
>
> Should we explicitly test that this is either XFS_ABTC_MAGIC or 
> XFS_ABTB_MAGIC here to avoid any programming-error
> type problems?

We really only have two freespace btrees.  But I'll add an assert
just to be sure.

>> -				else  {
>> +					break;
>> +				case XR_E_FREE1:
>> +					/*
>> +					 * no warning messages -- we'll catch
>> +					 * FREE1 blocks later
>> +					 */
>> +					if (magic != XFS_ABTB_MAGIC) {
>
> Why not make this explicitly "if (magic == XFS_ABTC_MAGIC)" - I guess it seems potentially
> more future-proof to me though I don't suppose we'll ever get a new type here.  :)
> The positive test seems clearer to me but *shrug*.

Ok, changed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
