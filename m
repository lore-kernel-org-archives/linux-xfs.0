Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n16KVtki049927 for <xfs@oss.sgi.com>; Fri, 6 Feb 2009 14:31:56 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C5B030418F
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2009 12:31:15 -0800 (PST)
Message-Id: <A62D78E5-78C5-4AD2-81E4-7C551DBD7452@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090206071717.GA3295@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 09/17] xfs: cleanup xfs_find_handle
Date: Fri, 6 Feb 2009 14:31:14 -0600
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.277472000@bombadil.infradead.org>
	<F4717E19-7A7F-40CD-BAEB-7AE519E797D0@sgi.com>
	<20090206071717.GA3295@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Feb 6, 2009, at 1:17 AM, Christoph Hellwig wrote:

> On Thu, Feb 05, 2009 at 11:20:22PM -0600, Felix Blyakher wrote:
>> Do we want to verify here that cmd is either XFS_IOC_PATH_TO_FSHANDLE
>> or XFS_IOC_PATH_TO_HANDLE ...
>
> It's called in a single place for just these three subcases, so having
> another verification here doesn't seem juseful.

Yes, I know it's called from xfs_file_ioctl() only, and only
with the those three commands, but I prefer the defensive code,
which would flag something unexpected rather then going the
wrong way.
Though, in this case, I'm not too much set on the "defensive"
side :)

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
