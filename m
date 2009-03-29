Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2T7nOfZ118411 for <xfs@oss.sgi.com>; Sun, 29 Mar 2009 02:49:40 -0500
Date: Sun, 29 Mar 2009 03:48:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] xfs: remove m_litino
Message-ID: <20090329074859.GG16402@infradead.org>
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.224487000@bombadil.infradead.org>
	<3D659CF1-738E-4580-B390-9E7B65C4BE2F@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3D659CF1-738E-4580-B390-9E7B65C4BE2F@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Mar 26, 2009 at 05:41:16PM -0500, Felix Blyakher wrote:
>
> On Mar 18, 2009, at 4:41 AM, Christoph Hellwig wrote:
>
>> With the upcoming v3 inodes the inode data/attr area size needs to be
>> calculated for each specific inode, so we can't cache it in the  
>> superblock
>> anymore.
>
> The change looks fine. But what is "v3 inodes"? I'm sure it's been
> mentioned on the list, I'm just missing the history.

It's the new inode format including a crc and uuid in the CRC patches.
Because it has a larger core dinode the litoral area calculcations need
to be more dynamic.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
