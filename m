Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C43B87F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 16:39:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 318F1AC008
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:39:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QEzmH4JlvrnCFpzW for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 14:39:38 -0700 (PDT)
Date: Wed, 16 Oct 2013 08:39:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsprogs: fix resource leak in longform_dir2_rebuild()
Message-ID: <20131015213936.GV4446@dastard>
References: <1381560174.3064.4.camel@ThinkPad-T5421>
	<20131014214601.GJ5663@dastard>
	<1381805731.3106.5.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381805731.3106.5.camel@ThinkPad-T5421>
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
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On Tue, Oct 15, 2013 at 10:55:31AM +0800, Li Zhong wrote:
> coverity scan 997010 reported following leak:
> 
> 1309                if (error) {
> 1310                        do_warn(
> 1311        _("space reservation failed (%d), filesystem may be out of space\n"),
> 1312                                error);
>     	25. Breaking from loop
> 1313                        break;
> 1314                }
> 
> ......
> 
> 1342                libxfs_trans_commit(tp,
> 1343                                XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_SYNC);
> 1344        }
> 
> CID 997010 (#1 of 1): Resource leak (RESOURCE_LEAK)
> 26. leaked_storage: Variable "tp" going out of scope leaks the storage it points to.
> 1345}
> 
> Though not reported by coverity, it seems that there might be some entries in
> flist which needs to be freed in the failure case below libxfs_dir_createname(),
> and libxfs_bunmapi().
> 
> The fix cleans up the code by stacking the error handling at the end of the
> function, and jumping to the error handler label for the above cases. (fail
> directly by calling res_failed() for reservation failure.)
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Looks much better. Thanks! :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
