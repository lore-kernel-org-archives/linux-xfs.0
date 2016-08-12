Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 23E467CA0
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 22:14:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24E11AC001
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 20:14:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mLbtU1GyeI7DhI2E (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 20:14:03 -0700 (PDT)
Date: Fri, 12 Aug 2016 11:14:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] xfs: test attr_list_by_handle cursor iteration
Message-ID: <20160812031400.GR27776@eguan.usersys.redhat.com>
References: <20160802235251.GB8586@birch.djwong.org>
	<20160803225150.GC25565@birch.djwong.org>
	<20160804042448.GR27776@eguan.usersys.redhat.com>
	<20160811174855.GD31540@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160811174855.GD31540@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Thu, Aug 11, 2016 at 10:48:55AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 04, 2016 at 12:24:48PM +0800, Eryu Guan wrote:
> > I have to replace false/true with 0/1 to build it on RHEL6. I can fix it
> > at commit time if there's no other major updates.
> 
> Simply including <stdbool.h> would fix that on RHEL6, wouldn't it?

Yes, including <stdbool.h> fixes the build failure on RHEL6, another
option is to replace all bool with int, as mentioned in my first review
email. And Darric chose the "int" way in v2 but only updated the
function definition and forgot to update the callers (still passing
true/false, not 1/0).

Thanks for the review!

Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
