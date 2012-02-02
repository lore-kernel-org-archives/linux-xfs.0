Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12AmdCW044868 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 04:48:40 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lv05XKzX4e7KVHQL (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 02:48:26 -0800 (PST)
Date: Thu, 2 Feb 2012 05:48:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair takes long time
Message-ID: <20120202104825.GA7670@infradead.org>
References: <D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A02@MX03A.corp.emc.com>
	<20120202091715.GC31203@infradead.org>
	<D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A10@MX03A.corp.emc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D6BB8A3C30275C45A0A5CA53D5CC37F80242C12A10@MX03A.corp.emc.com>
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
To: Kiran.Chandapu@emc.com
Cc: hch@infradead.org, xfs@oss.sgi.com

On Thu, Feb 02, 2012 at 04:29:00AM -0500, Kiran.Chandapu@emc.com wrote:
> Hello Christoph, 
> 
> Thanks, I would try to upgrade it. Could you please tell me whether we can recover the data, actually we have all our data about 12 TB resides on that volume which has the issue. 

Given your description of missing LV metadata I suspect that you
actually have lost part if not all of the filesystem.  Running
xfs_repair -nv will give you more information about, but if you have
indeed destroyed the lvm block mapping it won't be able to do much.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
