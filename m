Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADKLguf141785 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 14:21:43 -0600
Message-ID: <50A2AC4F.3030506@sgi.com>
Date: Tue, 13 Nov 2012 14:23:43 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfstests: remove unsupported conditionals
References: <20121109132358.256359544@sgi.com>
	<20121109132713.922668905@sgi.com>
In-Reply-To: <20121109132713.922668905@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On 11/09/12 07:23, rjohnston@sgi.com wrote:
> This patch removes the unsupported sgi and CRAY.
>
> Signed-off-by: Rich Johnston<rjohnston@sgi.com>
>
> ---
>   dmapi/src/common/lib/dmport.h         |   16
>   dmapi/src/common/lib/util.c           |   16
>   dmapi/src/sample_hsm/wbee.c           |    2
>   dmapi/src/simple/dm_create_session.c  |    3
>   dmapi/src/simple/dm_destroy_session.c |    3
>   dmapi/src/simple/dm_find_eventmsg.c   |    3
>   dmapi/src/simple/dm_getall_sessions.c |    3
>   dmapi/src/simple/dm_getall_tokens.c   |    3
>   dmapi/src/simple/dm_query_session.c   |    3
>   dmapi/src/suite1/cmd/get_mountinfo.c  |    4
>   dmapi/src/suite1/cmd/make_rt_sparse.c |    7
>   dmapi/src/suite1/cmd/print_event.c    |    8
>   dmapi/src/suite1/cmd/print_fshandle.c |   21
>   dmapi/src/suite2/src/check_dmapi.c    |   25
>   dmapi/src/suite2/src/dm_test_daemon.c |   20
>   dmapi/src/suite2/src/mmap.c           |   12
>   dmapi/src/suite2/src/test_invis.c     |   43
>   include/test.h                        |   17
>   include/tlibio.h                      |   40
>   include/usctest.h                     |    2
>   include/write_log.h                   |    8
>   lib/datapid.c                         |  179 ---
>   lib/random_range.c                    |   34
>   lib/str_to_bytes.c                    |    6
>   lib/tlibio.c                          |  777 --------------
>   ltp/doio.c                            | 1866 +---------------------------------
>   ltp/doio.h                            |    6
>   ltp/growfiles.c                       |  162 --
>   ltp/iogen.c                           |  307 -----
>   src/dirperf.c                         |    2
>   src/dmiperf.c                         |    6
>   src/global.h                          |    5
>   src/multi_open_unlink.c               |    4
>   src/randholes.c                       |    5
>   34 files changed, 101 insertions(+), 3517 deletions(-)


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
