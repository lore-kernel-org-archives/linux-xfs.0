Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0DAE97F78
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 13:20:12 -0500 (CDT)
Date: Mon, 19 Aug 2013 13:20:08 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v8 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
Message-ID: <20130819182008.GP12719@sgi.com>
References: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
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
Cc: xfs@oss.sgi.com

On Thu, Aug 15, 2013 at 02:07:57PM -0400, Dwight Engen wrote:
> This patchset adds USER_NS support to XFS. It has been rebased on top
> of 2c2bcc07 git://oss.sgi.com/xfs/xfs.git master branch.
> 
> The patches do not convert the id's returned from bulkstat, since bulkstat
> cannot be called from inside a userns right now anyway since the caller
> must be CAP_SYS_ADMIN in init_user_ns. Similar checks ensure that
> open_by_handle, and changing of projid can also only be called from
> init_user_ns.

Thanks kindly Dwight.  I have applied this series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
