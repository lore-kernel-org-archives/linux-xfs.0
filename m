Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3DE4B7FBD
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 09:43:09 -0600 (CST)
Message-ID: <5130CC8E.6090406@sgi.com>
Date: Fri, 1 Mar 2013 09:43:10 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 01/10] xfstests: add fio requirement V2
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-2-git-send-email-dmonakhov@openvz.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> FIO is very flexible io generator, I would call it IO swiss knife.
> Currently we have tonns of hardcoded application which reproduces
> some predefined scenario. This approach has obvious dissadvantages
> 1) Lack of flexability: one written it is hard to modify it in future
> 2) Code base is large, many routines written again and again
>
> At the same time add new fio based tast is just add simle INI file.
> This greatly simplify code review. I do beleve that some day we will
> replace most of hardcoded io binaries with fio.
>
> One who is planning to run $FIO_PROG should first check that system
> contains appropriate version which is able to handle jobfile
> for example:  _require_fio 286-job.fio
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Minor typos in the description, but looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
