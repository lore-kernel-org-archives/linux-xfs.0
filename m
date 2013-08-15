Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 950A67F54
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 12:17:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FD6FAC003
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 10:17:06 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gT7ZPBUkxBgtO7DJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 10:17:04 -0700 (PDT)
Date: Thu, 15 Aug 2013 13:16:24 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH v8 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
Message-ID: <20130815131624.4b09b62a@oracle.com>
In-Reply-To: <20130813210039.GC12719@sgi.com>
References: <20130801112953.48c2870b@oracle.com>
	<20130813210039.GC12719@sgi.com>
Mime-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com, Gao feng <gaofeng@cn.fujitsu.com>, "Eric W. Biederman" <ebiederm@gmail.com>

On Tue, 13 Aug 2013 16:00:39 -0500
Ben Myers <bpm@sgi.com> wrote:

> Hi Dwight,
> 
> On Thu, Aug 01, 2013 at 11:29:53AM -0400, Dwight Engen wrote:
> > Hi All,
> > 
> > This updated patchset is on top of 7a378c9a (HEAD) of xfs git. The
> > patches do not convert the id's returned from bulkstat, since
> > bulkstat cannot be called from inside a userns right now anyway
> > since the caller must be CAP_SYS_ADMIN in init_user_ns. Similar
> > checks ensure that open_by_handle, and changing of projid can also
> > only be called from init_user_ns.
> 
> We pulled in Dave's kernel/libxfs sync series yesterday.  Could you
> rebase this on git://oss.sgi.com/xfs/xfs.git master branch?  Sorry
> for the inconvenience.

Sure I'll rebase it and repost shortly.

> Thanks,
> 	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
