Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 519737F8C
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 16:00:43 -0500 (CDT)
Date: Tue, 13 Aug 2013 16:00:39 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v8 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
Message-ID: <20130813210039.GC12719@sgi.com>
References: <20130801112953.48c2870b@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801112953.48c2870b@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com, Gao feng <gaofeng@cn.fujitsu.com>, "Eric W. Biederman" <ebiederm@gmail.com>

Hi Dwight,

On Thu, Aug 01, 2013 at 11:29:53AM -0400, Dwight Engen wrote:
> Hi All,
> 
> This updated patchset is on top of 7a378c9a (HEAD) of xfs git. The
> patches do not convert the id's returned from bulkstat, since bulkstat
> cannot be called from inside a userns right now anyway since the caller
> must be CAP_SYS_ADMIN in init_user_ns. Similar checks ensure that
> open_by_handle, and changing of projid can also only be called from
> init_user_ns.

We pulled in Dave's kernel/libxfs sync series yesterday.  Could you rebase this
on git://oss.sgi.com/xfs/xfs.git master branch?  Sorry for the inconvenience.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
