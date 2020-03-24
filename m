Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A79FC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03446205ED
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yeIL6Rr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgCXUog (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:44:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgCXUog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:44:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKeJNl038401;
        Tue, 24 Mar 2020 20:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ALrKSpkIkZly2kNEVd4wdPXDeHHL/bim54OpXcHieM0=;
 b=yeIL6Rr1zAtKZJu0xUP5YpOI5MbQ0amUhlEJ7U51DbVOMZ99CiLPtwVUd4+JVavBXPvB
 bWq1kU5qgmJfxJKEU9Oz2jleQFZZLQG03ReQVJQA5m2EBxSu4OymjmItp/EZdHyGeMvA
 /Uzt5BO6e7BYvGwpoa5tqElDXdSG7XhWysMfAXe/jU1dXN08VwxdMlUL0UwPk59iUEo1
 9fghfgd+UTEHvMlGR+cTjHcbNn4FVObj4ppf88NabfSB9veLzIWISKAkKsiCppOVEhrk
 c1jnRi7WLY4GPUrvHNQbyGNlEKG97F1Q2dNI/aiyjLxUN9Dy8fjbBwLwsx4svnIwOqSR zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yx8ac3jdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:44:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKbmfV094325;
        Tue, 24 Mar 2020 20:44:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yxw939xph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:44:33 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OKiVwp005006;
        Tue, 24 Mar 2020 20:44:32 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:44:31 -0700
Date:   Tue, 24 Mar 2020 13:44:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfsprogs: fix sliently borken option parsing
Message-ID: <20200324204429.GP29339@magnolia>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324001928.17894-5-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:19:27AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When getopt() is passed an option string like "-m -n" and the
> parameter m is defined as "m:", getopt returns a special error
> to indication that the optstring started with a "-". Any getopt()
> caller that is just catching the "?" error character will not
> not catch this special error, so it silently eats the parameter
> following -m.
> 
> Lots of getopt loops in xfsprogs have this issue. Convert them all
> to just use a "default:" to catch anything unexpected.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ooops....
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  copy/xfs_copy.c      | 2 +-
>  db/freesp.c          | 2 +-
>  db/init.c            | 7 ++-----
>  growfs/xfs_growfs.c  | 1 -
>  io/copy_file_range.c | 2 ++
>  logprint/logprint.c  | 2 +-
>  mkfs/xfs_mkfs.c      | 2 +-
>  repair/xfs_repair.c  | 2 +-
>  scrub/xfs_scrub.c    | 2 --
>  spaceman/freesp.c    | 1 -
>  spaceman/prealloc.c  | 1 -
>  11 files changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 91c2ae01683b..c4f9f34981ca 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -584,7 +584,7 @@ main(int argc, char **argv)
>  		case 'V':
>  			printf(_("%s version %s\n"), progname, VERSION);
>  			exit(0);
> -		case '?':
> +		default:
>  			usage();
>  		}
>  	}
> diff --git a/db/freesp.c b/db/freesp.c
> index 903c60d7380a..6f2346665847 100644
> --- a/db/freesp.c
> +++ b/db/freesp.c
> @@ -177,7 +177,7 @@ init(
>  		case 's':
>  			summaryflag = 1;
>  			break;
> -		case '?':
> +		default:
>  			return usage();
>  		}
>  	}
> diff --git a/db/init.c b/db/init.c
> index 61eea111f017..ac649fbddbb9 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -84,15 +84,12 @@ init(
>  		case 'V':
>  			printf(_("%s version %s\n"), progname, VERSION);
>  			exit(0);
> -		case '?':
> +		default:
>  			usage();
> -			/*NOTREACHED*/
>  		}
>  	}
> -	if (optind + 1 != argc) {
> +	if (optind + 1 != argc)
>  		usage();
> -		/*NOTREACHED*/
> -	}
>  
>  	fsdevice = argv[optind];
>  	if (!x.disfile)
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index d27e3b94e0c4..a68b515de40d 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -120,7 +120,6 @@ main(int argc, char **argv)
>  		case 'V':
>  			printf(_("%s version %s\n"), progname, VERSION);
>  			exit(0);
> -		case '?':
>  		default:
>  			usage();
>  		}
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index fb5702e1faad..4c4332c6e5ec 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -127,6 +127,8 @@ copy_range_f(int argc, char **argv)
>  			/* Expect no src_path arg */
>  			src_path_arg = 0;
>  			break;
> +		default:
> +			return command_usage(&copy_range_cmd);
>  		}
>  	}
>  
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index 511a32aca726..e882c5d44397 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -193,7 +193,7 @@ main(int argc, char **argv)
>  			case 'V':
>  				printf(_("%s version %s\n"), progname, VERSION);
>  				exit(0);
> -			case '?':
> +			default:
>  				usage();
>  		}
>  	}
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f14ce8db5a74..039b1dcc5afa 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3679,7 +3679,7 @@ main(
>  		case 'V':
>  			printf(_("%s version %s\n"), progname, VERSION);
>  			exit(0);
> -		case '?':
> +		default:
>  			unknown(optopt, "");
>  		}
>  	}
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 4d37ddc64906..e509fdeb66fe 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -326,7 +326,7 @@ process_args(int argc, char **argv)
>  		case 'e':
>  			report_corrected = true;
>  			break;
> -		case '?':
> +		default:
>  			usage();
>  		}
>  	}
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 014c54dd76b2..33b876f2147a 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -671,8 +671,6 @@ main(
>  		case 'x':
>  			scrub_data = true;
>  			break;
> -		case '?':
> -			/* fall through */
>  		default:
>  			usage();
>  		}
> diff --git a/spaceman/freesp.c b/spaceman/freesp.c
> index 92cdb7439427..de301c195fb3 100644
> --- a/spaceman/freesp.c
> +++ b/spaceman/freesp.c
> @@ -310,7 +310,6 @@ init(
>  		case 's':
>  			summaryflag = 1;
>  			break;
> -		case '?':
>  		default:
>  			return command_usage(&freesp_cmd);
>  		}
> diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
> index e5d857bdd334..6fcbb461125b 100644
> --- a/spaceman/prealloc.c
> +++ b/spaceman/prealloc.c
> @@ -56,7 +56,6 @@ prealloc_f(
>  			eofb.eof_min_file_size = cvtnum(fsgeom->blocksize,
>  					fsgeom->sectsize, optarg);
>  			break;
> -		case '?':
>  		default:
>  			return command_usage(&prealloc_cmd);
>  		}
> -- 
> 2.26.0.rc2
> 
