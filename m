Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5461CC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0EE6205ED
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n5r+J7tD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgCXUsG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:48:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgCXUsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:48:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKdMEf056129;
        Tue, 24 Mar 2020 20:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nPep275AcUZvVzUaUGm34lWwy6JakfNiJPLcY2imkC0=;
 b=n5r+J7tDUeDfQysIzKT9XM5MUR/qUACgMWi8vzHaVlc0lHKRJ7wvUIKSNrfHZtY4Ytxn
 mT34tZyQ9sx96K5Hh0lDuiDRv/HTe/msD1FixIbg2uSEPA/yE0wK7bMLf8J4J7BTkcg4
 CE4t1P/a911jdUKTtg84AeTkQfs8q+T+FfqSYgnY7iV2KHvnZWW6pLUAnacR8sgzSZ8K
 KfutfV4xbvUxPRlP5D3fcJVu4nfq/WadyillQg6LxFzMYybeBm51nPm7MIrarFm1pik9
 xlZdjnE66TdvPwTa53mqxpR2Gr/Qu198Y/EtY7KEy7f1H8M8OAHCsHK5XrjTMKm7hgbq 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ywabr6mg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:48:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKcvKg038444;
        Tue, 24 Mar 2020 20:48:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4q136f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:48:01 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OKm07K012278;
        Tue, 24 Mar 2020 20:48:00 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:47:59 -0700
Date:   Tue, 24 Mar 2020 13:47:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_io: set exitcode on failure appropriately
Message-ID: <20200324204758.GQ29339@magnolia>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324001928.17894-6-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:19:28AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Many operations don't set the exitcode when they fail, resulting
> in xfs_io exiting with a zero (no failure) exit code despite the
> command failing and returning an error. The command return code is
> really a boolean to tell the libxcmd command loop whether to
> continue processing or not, while exitcode is the actual xfs_io exit
> code returned to the parent on exit.
> 
> This patchset just makes the code do the right thing. It's not the
> nicest code, but it's a start at producing correct behaviour.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks fine to me, but we're also going to need to audit db, quota, and
spaceman too, right?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  io/attr.c            | 24 +++++++++---
>  io/copy_file_range.c | 16 +++++++-
>  io/cowextsize.c      |  5 +++
>  io/encrypt.c         | 29 +++++++++++---
>  io/fadvise.c         |  9 ++++-
>  io/fiemap.c          |  3 ++
>  io/file.c            |  1 +
>  io/fsmap.c           |  9 ++++-
>  io/fsync.c           |  2 +
>  io/getrusage.c       |  1 +
>  io/imap.c            |  1 +
>  io/inject.c          |  1 +
>  io/link.c            |  1 +
>  io/log_writes.c      | 28 +++++++-------
>  io/madvise.c         | 10 ++++-
>  io/mincore.c         | 10 ++++-
>  io/mmap.c            | 62 ++++++++++++++++++++++++------
>  io/open.c            | 91 +++++++++++++++++++++++++++++++++-----------
>  io/parent.c          |  1 +
>  io/pread.c           | 19 +++++++--
>  io/prealloc.c        | 55 ++++++++++++++++++++------
>  io/pwrite.c          | 31 ++++++++++++---
>  io/readdir.c         | 10 +++--
>  io/reflink.c         | 30 ++++++++++++---
>  io/resblks.c         |  3 ++
>  io/seek.c            | 12 ++++--
>  io/sendfile.c        | 18 +++++++--
>  io/shutdown.c        |  2 +
>  io/stat.c            | 13 ++++++-
>  io/sync_file_range.c |  8 +++-
>  io/truncate.c        |  2 +
>  io/utimes.c          |  3 ++
>  32 files changed, 411 insertions(+), 99 deletions(-)
> 
> diff --git a/io/attr.c b/io/attr.c
> index 69b32956ab88..80e285147acb 100644
> --- a/io/attr.c
> +++ b/io/attr.c
> @@ -162,13 +162,15 @@ lsattr_callback(
>  	if (recurse_dir && !S_ISDIR(stat->st_mode))
>  		return 0;
>  
> -	if ((fd = open(path, O_RDONLY)) == -1)
> +	if ((fd = open(path, O_RDONLY)) == -1) {
>  		fprintf(stderr, _("%s: cannot open %s: %s\n"),
>  			progname, path, strerror(errno));
> -	else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0)
> +		exitcode = 1;
> +	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
>  			progname, path, strerror(errno));
> -	else
> +		exitcode = 1;
> +	} else
>  		printxattr(fsx.fsx_xflags, 0, 1, path, 0, 1);
>  
>  	if (fd != -1)
> @@ -205,6 +207,7 @@ lsattr_f(
>  			vflag = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&lsattr_cmd);
>  		}
>  	}
> @@ -215,6 +218,7 @@ lsattr_f(
>  	} else if ((xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
>  			progname, name, strerror(errno));
> +		exitcode = 1;
>  	} else {
>  		printxattr(fsx.fsx_xflags, vflag, !aflag, name, vflag, !aflag);
>  		if (aflag) {
> @@ -241,15 +245,19 @@ chattr_callback(
>  	if ((fd = open(path, O_RDONLY)) == -1) {
>  		fprintf(stderr, _("%s: cannot open %s: %s\n"),
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
>  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  	} else {
>  		attr.fsx_xflags |= orflags;
>  		attr.fsx_xflags &= ~andflags;
> -		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0)
> +		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0) {
>  			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
>  				progname, path, strerror(errno));
> +			exitcode = 1;
> +		}
>  	}
>  
>  	if (fd != -1)
> @@ -285,6 +293,7 @@ chattr_f(
>  				if (!p->flag) {
>  					fprintf(stderr, _("%s: unknown flag\n"),
>  						progname);
> +					exitcode = 1;
>  					return 0;
>  				}
>  			}
> @@ -299,12 +308,14 @@ chattr_f(
>  				if (!p->flag) {
>  					fprintf(stderr, _("%s: unknown flag\n"),
>  						progname);
> +					exitcode = 1;
>  					return 0;
>  				}
>  			}
>  		} else {
>  			fprintf(stderr, _("%s: bad chattr command, not +/-X\n"),
>  				progname);
> +			exitcode = 1;
>  			return 0;
>  		}
>  	}
> @@ -315,12 +326,15 @@ chattr_f(
>  	} else if (xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &attr) < 0) {
>  		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
>  			progname, name, strerror(errno));
> +		exitcode = 1;
>  	} else {
>  		attr.fsx_xflags |= orflags;
>  		attr.fsx_xflags &= ~andflags;
> -		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0)
> +		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0) {
>  			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
>  				progname, name, strerror(errno));
> +			exitcode = 1;
> +		}
>  	}
>  	return 0;
>  }
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index 4c4332c6e5ec..685250471020 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -89,6 +89,7 @@ copy_range_f(int argc, char **argv)
>  			src_off = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (src_off < 0) {
>  				printf(_("invalid source offset -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -96,6 +97,7 @@ copy_range_f(int argc, char **argv)
>  			dst_off = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (dst_off < 0) {
>  				printf(_("invalid destination offset -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -103,6 +105,7 @@ copy_range_f(int argc, char **argv)
>  			llen = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (llen == -1LL) {
>  				printf(_("invalid length -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			/*
> @@ -112,6 +115,7 @@ copy_range_f(int argc, char **argv)
>  			if ((size_t)llen != llen) {
>  				errno = EOVERFLOW;
>  				perror("copy_range");
> +				exitcode = 1;
>  				return 0;
>  			}
>  			len = llen;
> @@ -122,23 +126,29 @@ copy_range_f(int argc, char **argv)
>  			if (src_file_nr < 0 || src_file_nr >= filecount) {
>  				printf(_("file value %d is out of range (0-%d)\n"),
>  					src_file_nr, filecount - 1);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			/* Expect no src_path arg */
>  			src_path_arg = 0;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&copy_range_cmd);
>  		}
>  	}
>  
> -	if (optind != argc - src_path_arg)
> +	if (optind != argc - src_path_arg) {
> +		exitcode = 1;
>  		return command_usage(&copy_range_cmd);
> +	}
>  
>  	if (src_path_arg) {
>  		fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
> -		if (fd < 0)
> +		if (fd < 0) {
> +			exitcode = 1;
>  			return 0;
> +		}
>  	} else {
>  		fd = filetable[src_file_nr].fd;
>  	}
> @@ -158,6 +168,8 @@ copy_range_f(int argc, char **argv)
>  	ret = copy_file_range_cmd(fd, &src_off, &dst_off, len);
>  out:
>  	close(fd);
> +	if (ret < 0)
> +		exitcode = 1;
>  	return ret;
>  }
>  
> diff --git a/io/cowextsize.c b/io/cowextsize.c
> index da5c6680c7d2..549634438aa4 100644
> --- a/io/cowextsize.c
> +++ b/io/cowextsize.c
> @@ -39,6 +39,7 @@ get_cowextsize(const char *path, int fd)
>  	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  		return 0;
>  	}
>  	printf("[%u] %s\n", fsx.fsx_cowextsize, path);
> @@ -53,11 +54,13 @@ set_cowextsize(const char *path, int fd, long extsz)
>  
>  	if (fstat64(fd, &stat) < 0) {
>  		perror("fstat64");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		printf("%s: XFS_IOC_FSGETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -72,6 +75,7 @@ set_cowextsize(const char *path, int fd, long extsz)
>  	if ((xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx)) < 0) {
>  		printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -154,6 +158,7 @@ cowextsize_f(
>  		if (cowextsize < 0) {
>  			printf(_("non-numeric cowextsize argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  	} else {
> diff --git a/io/encrypt.c b/io/encrypt.c
> index 01b7e0df8a6e..1b347dc1afdb 100644
> --- a/io/encrypt.c
> +++ b/io/encrypt.c
> @@ -603,6 +603,7 @@ set_encpolicy_f(int argc, char **argv)
>  				fprintf(stderr,
>  					_("invalid contents encryption mode: %s\n"),
>  					optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -611,6 +612,7 @@ set_encpolicy_f(int argc, char **argv)
>  				fprintf(stderr,
>  					_("invalid filenames encryption mode: %s\n"),
>  					optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -618,6 +620,7 @@ set_encpolicy_f(int argc, char **argv)
>  			if (!parse_byte_value(optarg, &flags)) {
>  				fprintf(stderr, _("invalid flags: %s\n"),
>  					optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -628,6 +631,7 @@ set_encpolicy_f(int argc, char **argv)
>  				fprintf(stderr,
>  					_("invalid policy version: %s\n"),
>  					optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			if (val == 1) /* Just to avoid annoying people... */
> @@ -636,14 +640,17 @@ set_encpolicy_f(int argc, char **argv)
>  			break;
>  		}
>  		default:
> +			exitcode = 1;
>  			return command_usage(&set_encpolicy_cmd);
>  		}
>  	}
>  	argc -= optind;
>  	argv += optind;
>  
> -	if (argc > 1)
> +	if (argc > 1) {
> +		exitcode = 1;
>  		return command_usage(&set_encpolicy_cmd);
> +	}
>  
>  	/*
>  	 * If unspecified, the key descriptor or identifier defaults to all 0's.
> @@ -652,8 +659,10 @@ set_encpolicy_f(int argc, char **argv)
>  	memset(&key_spec, 0, sizeof(key_spec));
>  	if (argc > 0) {
>  		version = str2keyspec(argv[0], version, &key_spec);
> -		if (version < 0)
> +		if (version < 0) {
> +			exitcode = 1;
>  			return 0;
> +		}
>  	}
>  	if (version < 0) /* version unspecified? */
>  		version = FSCRYPT_POLICY_V1;
> @@ -735,6 +744,7 @@ add_enckey_f(int argc, char **argv)
>  				goto out;
>  			break;
>  		default:
> +			exitcode = 1;
>  			retval = command_usage(&add_enckey_cmd);
>  			goto out;
>  		}
> @@ -743,6 +753,7 @@ add_enckey_f(int argc, char **argv)
>  	argv += optind;
>  
>  	if (argc != 0) {
> +		exitcode = 1;
>  		retval = command_usage(&add_enckey_cmd);
>  		goto out;
>  	}
> @@ -760,6 +771,7 @@ add_enckey_f(int argc, char **argv)
>  			fprintf(stderr,
>  				_("Invalid key; got > FSCRYPT_MAX_KEY_SIZE (%d) bytes on stdin!\n"),
>  				FSCRYPT_MAX_KEY_SIZE);
> +			exitcode = 1;
>  			goto out;
>  		}
>  		arg->raw_size = raw_size;
> @@ -794,17 +806,22 @@ rm_enckey_f(int argc, char **argv)
>  			ioc = FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&rm_enckey_cmd);
>  		}
>  	}
>  	argc -= optind;
>  	argv += optind;
>  
> -	if (argc != 1)
> +	if (argc != 1) {
> +		exitcode = 1;
>  		return command_usage(&rm_enckey_cmd);
> +	}
>  
> -	if (str2keyspec(argv[0], -1, &arg.key_spec) < 0)
> +	if (str2keyspec(argv[0], -1, &arg.key_spec) < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (ioctl(file->fd, ioc, &arg) != 0) {
>  		fprintf(stderr, _("Error removing encryption key: %s\n"),
> @@ -834,8 +851,10 @@ enckey_status_f(int argc, char **argv)
>  
>  	memset(&arg, 0, sizeof(arg));
>  
> -	if (str2keyspec(argv[1], -1, &arg.key_spec) < 0)
> +	if (str2keyspec(argv[1], -1, &arg.key_spec) < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_KEY_STATUS, &arg) != 0) {
>  		fprintf(stderr, _("Error getting encryption key status: %s\n"),
> diff --git a/io/fadvise.c b/io/fadvise.c
> index 4089a0eb2b2e..60cc0f088465 100644
> --- a/io/fadvise.c
> +++ b/io/fadvise.c
> @@ -65,19 +65,23 @@ fadvise_f(
>  			range = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&fadvise_cmd);
>  		}
>  	}
>  	if (range) {
>  		size_t	blocksize, sectsize;
>  
> -		if (optind != argc - 2)
> +		if (optind != argc - 2) {
> +			exitcode = 1;
>  			return command_usage(&fadvise_cmd);
> +		}
>  		init_cvtnum(&blocksize, &sectsize);
>  		offset = cvtnum(blocksize, sectsize, argv[optind]);
>  		if (offset < 0) {
>  			printf(_("non-numeric offset argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		optind++;
> @@ -85,14 +89,17 @@ fadvise_f(
>  		if (length < 0) {
>  			printf(_("non-numeric length argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  	} else if (optind != argc) {
> +		exitcode = 1;
>  		return command_usage(&fadvise_cmd);
>  	}
>  
>  	if (posix_fadvise(file->fd, offset, length, advise) < 0) {
>  		perror("fadvise");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/fiemap.c b/io/fiemap.c
> index 485bae16ebaa..f0c74dfe606d 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -257,6 +257,7 @@ fiemap_f(
>  			vflag++;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&fiemap_cmd);
>  		}
>  	}
> @@ -266,6 +267,7 @@ fiemap_f(
>  		start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  		if (start_offset < 0) {
>  			printf("non-numeric offset argument -- %s\n", argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		last_logical = start_offset;
> @@ -277,6 +279,7 @@ fiemap_f(
>  		length = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  		if (length < 0) {
>  			printf("non-numeric len argument -- %s\n", argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		range_end = start_offset + length;
> diff --git a/io/file.c b/io/file.c
> index c45486ecfac2..3af829eadb8b 100644
> --- a/io/file.c
> +++ b/io/file.c
> @@ -69,6 +69,7 @@ file_f(
>  	i = atoi(argv[1]);
>  	if (i < 0 || i >= filecount) {
>  		printf(_("value %d is out of range (0-%d)\n"), i, filecount-1);
> +		exitcode = 1;
>  	} else {
>  		file = &filetable[i];
>  		filelist_f();
> diff --git a/io/fsmap.c b/io/fsmap.c
> index feacb264a9d0..4b2175957f9c 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -417,13 +417,16 @@ fsmap_f(
>  			vflag++;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&fsmap_cmd);
>  		}
>  	}
>  
>  	if ((dflag + lflag + rflag > 1) || (mflag > 0 && vflag > 0) ||
> -	    (argc > optind && dflag + lflag + rflag == 0))
> +	    (argc > optind && dflag + lflag + rflag == 0)) {
> +		exitcode = 1;
>  		return command_usage(&fsmap_cmd);
> +	}
>  
>  	if (argc > optind) {
>  		start = cvtnum(fsblocksize, fssectsize, argv[optind]);
> @@ -431,6 +434,7 @@ fsmap_f(
>  			fprintf(stderr,
>  				_("Bad rmap start_bblock %s.\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		start <<= BBSHIFT;
> @@ -442,6 +446,7 @@ fsmap_f(
>  			fprintf(stderr,
>  				_("Bad rmap end_bblock %s.\n"),
>  				argv[optind + 1]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		end <<= BBSHIFT;
> @@ -495,8 +500,8 @@ fsmap_f(
>  				" iflags=0x%x [\"%s\"]: %s\n"),
>  				progname, head->fmh_iflags, file->name,
>  				strerror(errno));
> -			free(head);
>  			exitcode = 1;
> +			free(head);
>  			return 0;
>  		}
>  		if (head->fmh_entries > map_size + 2) {
> diff --git a/io/fsync.c b/io/fsync.c
> index e6f2331199be..b425b61222d7 100644
> --- a/io/fsync.c
> +++ b/io/fsync.c
> @@ -19,6 +19,7 @@ fsync_f(
>  {
>  	if (fsync(file->fd) < 0) {
>  		perror("fsync");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -31,6 +32,7 @@ fdatasync_f(
>  {
>  	if (fdatasync(file->fd) < 0) {
>  		perror("fdatasync");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/getrusage.c b/io/getrusage.c
> index 6962913df44f..11f86529bf77 100644
> --- a/io/getrusage.c
> +++ b/io/getrusage.c
> @@ -51,6 +51,7 @@ getrusage_f(
>  
>  	if (getrusage(RUSAGE_SELF, &rusage) < 0) {
>  		perror("getrusage");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> diff --git a/io/imap.c b/io/imap.c
> index e75dad1a5de9..837b338215ae 100644
> --- a/io/imap.c
> +++ b/io/imap.c
> @@ -31,6 +31,7 @@ imap_f(int argc, char **argv)
>  	error = -xfrog_inumbers_alloc_req(nent, 0, &ireq);
>  	if (error) {
>  		xfrog_perror(error, "alloc req");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> diff --git a/io/inject.c b/io/inject.c
> index cabfc3e362d9..4191c84ead41 100644
> --- a/io/inject.c
> +++ b/io/inject.c
> @@ -123,6 +123,7 @@ inject_f(
>  			command = XFS_IOC_ERROR_CLEARALL;
>  		if ((xfsctl(file->name, file->fd, command, &error)) < 0) {
>  			perror("XFS_IOC_ERROR_INJECTION");
> +			exitcode = 1;
>  			continue;
>  		}
>  	}
> diff --git a/io/link.c b/io/link.c
> index f4f4b1396951..8d255dee6f5f 100644
> --- a/io/link.c
> +++ b/io/link.c
> @@ -35,6 +35,7 @@ flink_f(
>  
>  	if (linkat(file->fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) < 0) {
>  		perror("flink");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/log_writes.c b/io/log_writes.c
> index 9c2285fed9eb..20049d1866f0 100644
> --- a/io/log_writes.c
> +++ b/io/log_writes.c
> @@ -15,10 +15,10 @@ static cmdinfo_t log_writes_cmd;
>  static int
>  mark_log(const char *device, const char *mark)
>  {
> -	struct dm_task 	*dmt;
> -	const int 	size = 80;
> -	char 		message[size];
> -	int 		len, ret = 0;
> +	struct dm_task	*dmt;
> +	const int	size = 80;
> +	char		message[size];
> +	int		len, ret = 0;
>  
>  	len = snprintf(message, size, "mark %s", mark);
>  	if (len >= size) {
> @@ -47,14 +47,13 @@ out:
>  
>  static int
>  log_writes_f(
> -	int			argc,
> -	char			**argv)
> +	int		argc,
> +	char		**argv)
>  {
> -	const char 	*device = NULL;
> -	const char 	*mark = NULL;
> -	int 		c;
> +	const char	*device = NULL;
> +	const char	*mark = NULL;
> +	int		c;
>  
> -	exitcode = 1;
>  	while ((c = getopt(argc, argv, "d:m:")) != EOF) {
>  		switch (c) {
>  		case 'd':
> @@ -64,15 +63,18 @@ log_writes_f(
>  			mark = optarg;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&log_writes_cmd);
>  		}
>  	}
>  
> -	if (device == NULL || mark == NULL)
> +	if (device == NULL || mark == NULL) {
> +		exitcode = 1;
>  		return command_usage(&log_writes_cmd);
> +	}
>  
> -	if (mark_log(device, mark))
> -		exitcode = 0;
> +	if (!mark_log(device, mark))
> +		exitcode = 1;
>  
>  	return 0;
>  }
> diff --git a/io/madvise.c b/io/madvise.c
> index 9f6c010d8a33..bde31539b606 100644
> --- a/io/madvise.c
> +++ b/io/madvise.c
> @@ -60,6 +60,7 @@ madvise_f(
>  			advise = MADV_WILLNEED;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&madvise_cmd);
>  		}
>  	}
> @@ -73,6 +74,7 @@ madvise_f(
>  		if (offset < 0) {
>  			printf(_("non-numeric offset argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		optind++;
> @@ -80,23 +82,29 @@ madvise_f(
>  		if (llength < 0) {
>  			printf(_("non-numeric length argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		} else if (llength > (size_t)llength) {
>  			printf(_("length argument too large -- %lld\n"),
>  				(long long)llength);
> +			exitcode = 1;
>  			return 0;
>  		} else
>  			length = (size_t)llength;
>  	} else {
> +		exitcode = 1;
>  		return command_usage(&madvise_cmd);
>  	}
>  
>  	start = check_mapping_range(mapping, offset, length, 1);
> -	if (!start)
> +	if (!start) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (madvise(start, length, advise) < 0) {
>  		perror("madvise");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/mincore.c b/io/mincore.c
> index 239134fedc8b..67f1d6c4b612 100644
> --- a/io/mincore.c
> +++ b/io/mincore.c
> @@ -34,36 +34,44 @@ mincore_f(
>  		if (offset < 0) {
>  			printf(_("non-numeric offset argument -- %s\n"),
>  				argv[1]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		llength = cvtnum(blocksize, sectsize, argv[2]);
>  		if (llength < 0) {
>  			printf(_("non-numeric length argument -- %s\n"),
>  				argv[2]);
> +			exitcode = 1;
>  			return 0;
>  		} else if (llength > (size_t)llength) {
>  			printf(_("length argument too large -- %lld\n"),
>  				(long long)llength);
> +			exitcode = 1;
>  			return 0;
>  		} else
>  			length = (size_t)llength;
>  	} else {
> +		exitcode = 1;
>  		return command_usage(&mincore_cmd);
>  	}
>  
>  	start = check_mapping_range(mapping, offset, length, 1);
> -	if (!start)
> +	if (!start) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	vec = calloc(length/pagesize, sizeof(unsigned char));
>  	if (!vec) {
>  		perror("calloc");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  	if (mincore(start, length, vec) < 0) {
>  		perror("mincore");
>  		free(vec);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> diff --git a/io/mmap.c b/io/mmap.c
> index f9383e5e790d..8c048a0ab6d0 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -113,6 +113,7 @@ mapset_f(
>  	i = atoi(argv[1]);
>  	if (i < 0 || i >= mapcount) {
>  		printf("value %d is out of range (0-%d)\n", i, mapcount);
> +		exitcode = 1;
>  	} else {
>  		mapping = &maptable[i];
>  		maplist_f();
> @@ -162,6 +163,7 @@ mmap_f(
>  		fprintf(stderr, file ?
>  			_("no mapped regions, try 'help mmap'\n") :
>  			_("no files are open, try 'help open'\n"));
> +		exitcode = 1;
>  		return 0;
>  	} else if (argc == 2) {
>  		if (mapping)
> @@ -169,9 +171,11 @@ mmap_f(
>  		fprintf(stderr, file ?
>  			_("no mapped regions, try 'help mmap'\n") :
>  			_("no files are open, try 'help open'\n"));
> +		exitcode = 1;
>  		return 0;
>  	} else if (!file) {
>  		fprintf(stderr, _("no files are open, try 'help open'\n"));
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -205,30 +209,36 @@ mmap_f(
>  			length2 = cvtnum(blocksize, sectsize, optarg);
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&mmap_cmd);
>  		}
>  	}
>  	if (!prot)
>  		prot = PROT_READ | PROT_WRITE | PROT_EXEC;
>  
> -	if (optind != argc - 2)
> +	if (optind != argc - 2) {
> +		exitcode = 1;
>  		return command_usage(&mmap_cmd);
> +	}
>  
>  	offset = cvtnum(blocksize, sectsize, argv[optind]);
>  	if (offset < 0) {
>  		printf(_("non-numeric offset argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
>  	length = cvtnum(blocksize, sectsize, argv[optind]);
>  	if (length < 0) {
>  		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  	filename = strdup(file->name);
>  	if (!filename) {
>  		perror("strdup");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -248,6 +258,7 @@ mmap_f(
>  	if (address == MAP_FAILED) {
>  		perror("mmap");
>  		free(filename);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -259,6 +270,7 @@ mmap_f(
>  		mapcount = 0;
>  		munmap(address, length);
>  		free(filename);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -313,6 +325,7 @@ msync_f(
>  			flags |= MS_SYNC;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&msync_cmd);
>  		}
>  	}
> @@ -326,6 +339,7 @@ msync_f(
>  		if (offset < 0) {
>  			printf(_("non-numeric offset argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		optind++;
> @@ -333,18 +347,25 @@ msync_f(
>  		if (length < 0) {
>  			printf(_("non-numeric length argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  	} else {
> +		exitcode = 1;
>  		return command_usage(&msync_cmd);
>  	}
>  
>  	start = check_mapping_range(mapping, offset, length, 1);
> -	if (!start)
> +	if (!start) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
> -	if (msync(start, length, flags) < 0)
> +	if (msync(start, length, flags) < 0) {
>  		perror("msync");
> +		exitcode = 1;
> +		return 0;
> +	}
>  
>  	return 0;
>  }
> @@ -399,6 +420,7 @@ mread_f(
>  			dump = 1;	/* mapping offset dump */
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&mread_cmd);
>  		}
>  	}
> @@ -412,6 +434,7 @@ mread_f(
>  		if (offset < 0) {
>  			printf(_("non-numeric offset argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		optind++;
> @@ -419,6 +442,7 @@ mread_f(
>  		if (length < 0) {
>  			printf(_("non-numeric length argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  	} else {
> @@ -426,16 +450,20 @@ mread_f(
>  	}
>  
>  	start = check_mapping_range(mapping, offset, length, 0);
> -	if (!start)
> +	if (!start) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  	dumpoffset = offset - mapping->offset;
>  	if (dump == 2)
>  		printoffset = offset;
>  	else
>  		printoffset = dumpoffset;
>  
> -	if (alloc_buffer(pagesize, 0, 0) < 0)
> +	if (alloc_buffer(pagesize, 0, 0) < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  	bp = (char *)io_buffer;
>  
>  	dumplen = length % pagesize;
> @@ -487,6 +515,7 @@ munmap_f(
>  
>  	if (munmap(mapping->addr, mapping->length) < 0) {
>  		perror("munmap");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	free(mapping->name);
> @@ -558,6 +587,7 @@ mwrite_f(
>  			}
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&mwrite_cmd);
>  		}
>  	}
> @@ -571,6 +601,7 @@ mwrite_f(
>  		if (offset < 0) {
>  			printf(_("non-numeric offset argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		optind++;
> @@ -578,15 +609,19 @@ mwrite_f(
>  		if (length < 0) {
>  			printf(_("non-numeric length argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  	} else {
> +		exitcode = 1;
>  		return command_usage(&mwrite_cmd);
>  	}
>  
>  	start = check_mapping_range(mapping, offset, length, 0);
> -	if (!start)
> +	if (!start) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	offset -= mapping->offset;
>  	if (rflag) {
> @@ -642,17 +677,21 @@ mremap_f(
>  			flags = MREMAP_MAYMOVE;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&mremap_cmd);
>  		}
>  	}
>  
> -	if (optind != argc - 1)
> +	if (optind != argc - 1) {
> +		exitcode = 1;
>  		return command_usage(&mremap_cmd);
> +	}
>  
>  	new_length = cvtnum(blocksize, sectsize, argv[optind]);
>  	if (new_length < 0) {
>  		printf(_("non-numeric offset argument -- %s\n"),
>  			argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -662,13 +701,14 @@ mremap_f(
>  	else
>  		new_addr = mremap(mapping->addr, mapping->length,
>  		                  new_length, flags, new_addr);
> -	if (new_addr == MAP_FAILED)
> +	if (new_addr == MAP_FAILED) {
>  		perror("mremap");
> -	else {
> -		mapping->addr = new_addr;
> -		mapping->length = new_length;
> +		exitcode = 1;
> +		return 0;
>  	}
>  
> +	mapping->addr = new_addr;
> +	mapping->length = new_length;
>  	return 0;
>  }
>  #endif /* HAVE_MREMAP */
> diff --git a/io/open.c b/io/open.c
> index 12990642b739..9a8b5e5c5904 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -244,6 +244,7 @@ open_f(
>  		if (file)
>  			return stat_f(argc, argv);
>  		fprintf(stderr, _("no files are open, try 'help open'\n"));
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -266,6 +267,7 @@ open_f(
>  			mode = strtoul(optarg, &sp, 0);
>  			if (!sp || sp == optarg) {
>  				printf(_("non-numeric mode -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -295,32 +297,43 @@ open_f(
>  			flags |= IO_NOFOLLOW;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&open_cmd);
>  		}
>  	}
>  
> -	if (optind != argc - 1)
> +	if (optind != argc - 1) {
> +		exitcode = 1;
>  		return command_usage(&open_cmd);
> +	}
>  
>  	if ((flags & (IO_READONLY|IO_TMPFILE)) == (IO_READONLY|IO_TMPFILE)) {
>  		fprintf(stderr, _("-T and -r options are incompatible\n"));
> +		exitcode = 1;
>  		return -1;
>  	}
>  
>  	if ((flags & (IO_PATH|IO_NOFOLLOW)) &&
>  	    (flags & ~(IO_PATH|IO_NOFOLLOW))) {
>  		fprintf(stderr, _("-P and -L are incompatible with the other options\n"));
> +		exitcode = 1;
>  		return -1;
>  	}
>  
>  	fd = openfile(argv[optind], &geometry, flags, mode, &fsp);
> -	if (fd < 0)
> +	if (fd < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (!platform_test_xfs_fd(fd))
>  		flags |= IO_FOREIGN;
>  
> -	addfile(argv[optind], fd, &geometry, flags, &fsp);
> +	if (addfile(argv[optind], fd, &geometry, flags, &fsp) != 0) {
> +		exitcode = 1;
> +		return 0;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -334,6 +347,7 @@ close_f(
>  
>  	if (close(file->fd) < 0) {
>  		perror("close");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	free(file->name);
> @@ -389,9 +403,12 @@ lsproj_callback(
>  	if ((fd = open(path, O_RDONLY)) == -1) {
>  		fprintf(stderr, _("%s: cannot open %s: %s\n"),
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  	} else {
>  		if (getprojid(path, fd, &projid) == 0)
>  			printf("[%u] %s\n", (unsigned int)projid, path);
> +		else
> +			exitcode = 1;
>  		close(fd);
>  	}
>  	return 0;
> @@ -417,19 +434,23 @@ lsproj_f(
>  			recurse_dir = 0;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&lsproj_cmd);
>  		}
>  	}
>  
> -	if (argc != optind)
> +	if (argc != optind) {
> +		exitcode = 1;
>  		return command_usage(&lsproj_cmd);
> +	}
>  
>  	if (recurse_all || recurse_dir)
>  		nftw(file->name, lsproj_callback,
>  			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
> -	else if (getprojid(file->name, file->fd, &projid) < 0)
> +	else if (getprojid(file->name, file->fd, &projid) < 0) {
>  		perror("getprojid");
> -	else
> +		exitcode = 1;
> +	} else
>  		printf(_("projid = %u\n"), (unsigned int)projid);
>  	return 0;
>  }
> @@ -461,9 +482,12 @@ chproj_callback(
>  	if ((fd = open(path, O_RDONLY)) == -1) {
>  		fprintf(stderr, _("%s: cannot open %s: %s\n"),
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  	} else {
> -		if (setprojid(path, fd, prid) < 0)
> +		if (setprojid(path, fd, prid) < 0) {
>  			perror("setprojid");
> +			exitcode = 1;
> +		}
>  		close(fd);
>  	}
>  	return 0;
> @@ -488,24 +512,30 @@ chproj_f(
>  			recurse_dir = 0;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&chproj_cmd);
>  		}
>  	}
>  
> -	if (argc != optind + 1)
> +	if (argc != optind + 1) {
> +		exitcode = 1;
>  		return command_usage(&chproj_cmd);
> +	}
>  
>  	prid = prid_from_string(argv[optind]);
>  	if (prid == -1) {
>  		printf(_("invalid project ID -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  	if (recurse_all || recurse_dir)
>  		nftw(file->name, chproj_callback,
>  			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
> -	else if (setprojid(file->name, file->fd, prid) < 0)
> +	else if (setprojid(file->name, file->fd, prid) < 0) {
>  		perror("setprojid");
> +		exitcode = 1;
> +	}
>  	return 0;
>  }
>  
> @@ -529,7 +559,7 @@ get_extsize(const char *path, int fd)
>  	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		printf("%s: FS_IOC_FSGETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
> -		return 0;
> +		return -1;
>  	}
>  	printf("[%u] %s\n", fsx.fsx_extsize, path);
>  	return 0;
> @@ -543,12 +573,12 @@ set_extsize(const char *path, int fd, long extsz)
>  
>  	if (fstat(fd, &stat) < 0) {
>  		perror("fstat");
> -		return 0;
> +		return -1;
>  	}
>  	if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
>  		printf("%s: FS_IOC_FSGETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
> -		return 0;
> +		return -1;
>  	}
>  
>  	if (S_ISREG(stat.st_mode)) {
> @@ -557,14 +587,14 @@ set_extsize(const char *path, int fd, long extsz)
>  		fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
>  	} else {
>  		printf(_("invalid target file type - file %s\n"), path);
> -		return 0;
> +		return -1;
>  	}
>  	fsx.fsx_extsize = extsz;
>  
>  	if ((xfsctl(path, fd, FS_IOC_FSSETXATTR, &fsx)) < 0) {
>  		printf("%s: FS_IOC_FSSETXATTR %s: %s\n",
>  			progname, path, strerror(errno));
> -		return 0;
> +		return -1;
>  	}
>  
>  	return 0;
> @@ -585,8 +615,10 @@ get_extsize_callback(
>  	if ((fd = open(path, O_RDONLY)) == -1) {
>  		fprintf(stderr, _("%s: cannot open %s: %s\n"),
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  	} else {
> -		get_extsize(path, fd);
> +		if (get_extsize(path, fd) < 0)
> +			exitcode = 1;
>  		close(fd);
>  	}
>  	return 0;
> @@ -607,8 +639,10 @@ set_extsize_callback(
>  	if ((fd = open(path, O_RDONLY)) == -1) {
>  		fprintf(stderr, _("%s: cannot open %s: %s\n"),
>  			progname, path, strerror(errno));
> +		exitcode = 1;
>  	} else {
> -		set_extsize(path, fd, extsize);
> +		if (set_extsize(path, fd, extsize) < 0)
> +			exitcode = 1;
>  		close(fd);
>  	}
>  	return 0;
> @@ -635,6 +669,7 @@ extsize_f(
>  			recurse_dir = 0;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&extsize_cmd);
>  		}
>  	}
> @@ -644,20 +679,23 @@ extsize_f(
>  		if (extsize < 0) {
>  			printf(_("non-numeric extsize argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  	} else {
>  		extsize = -1;
>  	}
>  
> -	if (recurse_all || recurse_dir)
> +	if (recurse_all || recurse_dir) {
>  		nftw(file->name, (extsize >= 0) ?
>  			set_extsize_callback : get_extsize_callback,
>  			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
> -	else if (extsize >= 0)
> -		set_extsize(file->name, file->fd, extsize);
> -	else
> -		get_extsize(file->name, file->fd);
> +	} else if (extsize >= 0) {
> +		if (set_extsize(file->name, file->fd, extsize) < 0)
> +			exitcode = 1;
> +	} else if (get_extsize(file->name, file->fd) < 0) {
> +		exitcode = 1;
> +	}
>  	return 0;
>  }
>  
> @@ -689,6 +727,7 @@ get_last_inode(void)
>  	ret = -xfrog_inumbers_alloc_req(IGROUP_NR, 0, &ireq);
>  	if (ret) {
>  		xfrog_perror(ret, "alloc req");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -696,6 +735,7 @@ get_last_inode(void)
>  		ret = -xfrog_inumbers(&xfd, ireq);
>  		if (ret) {
>  			xfrog_perror(ret, "XFS_IOC_FSINUMBERS");
> +			exitcode = 1;
>  			goto out;
>  		}
>  
> @@ -744,6 +784,7 @@ inode_f(
>  			ret_next = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&inode_cmd);
>  		}
>  	}
> @@ -761,12 +802,16 @@ inode_f(
>  	}
>  
>  	/* Extra junk? */
> -	if (optind < argc)
> +	if (optind < argc) {
> +		exitcode = 1;
>  		return command_usage(&inode_cmd);
> +	}
>  
>  	/* -n option requires an inode number */
> -	if (ret_next && userino == NULLFSINO)
> +	if (ret_next && userino == NULLFSINO) {
> +		exitcode = 1;
>  		return command_usage(&inode_cmd);
> +	}
>  
>  	if (userino == NULLFSINO) {
>  		/* We are finding last inode in use */
> diff --git a/io/parent.c b/io/parent.c
> index a78b45884be0..8f63607ffec2 100644
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -375,6 +375,7 @@ parent_f(int argc, char **argv)
>  	if (!fs) {
>  		fprintf(stderr, _("file argument, \"%s\", is not in a mounted XFS filesystem\n"),
>  			file->name);
> +		exitcode = 1;
>  		return 1;
>  	}
>  	mntpt = fs->fs_dir;
> diff --git a/io/pread.c b/io/pread.c
> index d52e21d965f0..971dbbc93363 100644
> --- a/io/pread.c
> +++ b/io/pread.c
> @@ -387,6 +387,7 @@ pread_f(
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (tmp < 0) {
>  				printf(_("non-numeric bsize -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			bsize = tmp;
> @@ -418,6 +419,7 @@ pread_f(
>  			if (!sp || sp == optarg) {
>  				printf(_("non-numeric vector count == %s\n"),
>  					optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -426,21 +428,26 @@ pread_f(
>  			zeed = strtoul(optarg, &sp, 0);
>  			if (!sp || sp == optarg) {
>  				printf(_("non-numeric seed -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&pread_cmd);
>  		}
>  	}
> -	if (optind != argc - 2)
> +	if (optind != argc - 2) {
> +		exitcode = 1;
>  		return command_usage(&pread_cmd);
> +	}
>  
>  	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (offset < 0 && (direction & (IO_RANDOM|IO_BACKWARD))) {
>  		eof = -1;	/* read from EOF */
>  	} else if (offset < 0) {
>  		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
> @@ -449,11 +456,14 @@ pread_f(
>  		eof = -1;	/* read to EOF */
>  	} else if (count < 0) {
>  		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> -	if (alloc_buffer(bsize, uflag, 0xabababab) < 0)
> +	if (alloc_buffer(bsize, uflag, 0xabababab) < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	gettimeofday(&t1, NULL);
>  	switch (direction) {
> @@ -473,8 +483,11 @@ pread_f(
>  	default:
>  		ASSERT(0);
>  	}
> -	if (c < 0)
> +	if (c < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
> +
>  	if (qflag)
>  		return 0;
>  	gettimeofday(&t2, NULL);
> diff --git a/io/prealloc.c b/io/prealloc.c
> index 6d452354ee45..382e811919c6 100644
> --- a/io/prealloc.c
> +++ b/io/prealloc.c
> @@ -76,11 +76,14 @@ allocsp_f(
>  {
>  	xfs_flock64_t	segment;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (xfsctl(file->name, file->fd, XFS_IOC_ALLOCSP64, &segment) < 0) {
>  		perror("XFS_IOC_ALLOCSP64");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -93,11 +96,14 @@ freesp_f(
>  {
>  	xfs_flock64_t	segment;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (xfsctl(file->name, file->fd, XFS_IOC_FREESP64, &segment) < 0) {
>  		perror("XFS_IOC_FREESP64");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -110,11 +116,14 @@ resvsp_f(
>  {
>  	xfs_flock64_t	segment;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (xfsctl(file->name, file->fd, XFS_IOC_RESVSP64, &segment) < 0) {
>  		perror("XFS_IOC_RESVSP64");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -127,11 +136,14 @@ unresvsp_f(
>  {
>  	xfs_flock64_t	segment;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (xfsctl(file->name, file->fd, XFS_IOC_UNRESVSP64, &segment) < 0) {
>  		perror("XFS_IOC_UNRESVSP64");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -144,11 +156,14 @@ zero_f(
>  {
>  	xfs_flock64_t	segment;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (xfsctl(file->name, file->fd, XFS_IOC_ZERO_RANGE, &segment) < 0) {
>  		perror("XFS_IOC_ZERO_RANGE");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -204,18 +219,24 @@ fallocate_f(
>  			mode = FALLOC_FL_UNSHARE_RANGE;
>  			break;
>  		default:
> +			exitcode = 1;
>  			command_usage(&falloc_cmd);
>  		}
>  	}
> -        if (optind != argc - 2)
> +        if (optind != argc - 2) {
> +		exitcode = 1;
>                  return command_usage(&falloc_cmd);
> +	}
>  
> -	if (!offset_length(argv[optind], argv[optind+1], &segment))
> +	if (!offset_length(argv[optind], argv[optind+1], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (fallocate(file->fd, mode,
>  			segment.l_start, segment.l_len)) {
>  		perror("fallocate");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -229,12 +250,15 @@ fpunch_f(
>  	xfs_flock64_t	segment;
>  	int		mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (fallocate(file->fd, mode,
>  			segment.l_start, segment.l_len)) {
>  		perror("fallocate");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -248,12 +272,15 @@ fcollapse_f(
>  	xfs_flock64_t	segment;
>  	int		mode = FALLOC_FL_COLLAPSE_RANGE;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (fallocate(file->fd, mode,
>  			segment.l_start, segment.l_len)) {
>  		perror("fallocate");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -267,12 +294,15 @@ finsert_f(
>  	xfs_flock64_t	segment;
>  	int		mode = FALLOC_FL_INSERT_RANGE;
>  
> -	if (!offset_length(argv[1], argv[2], &segment))
> +	if (!offset_length(argv[1], argv[2], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (fallocate(file->fd, mode,
>  			segment.l_start, segment.l_len)) {
>  		perror("fallocate");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> @@ -318,12 +348,15 @@ funshare_f(
>  	int		mode = FALLOC_FL_UNSHARE_RANGE;
>  	int		index = 1;
>  
> -	if (!offset_length(argv[index], argv[index + 1], &segment))
> +	if (!offset_length(argv[index], argv[index + 1], &segment)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (fallocate(file->fd, mode,
>  			segment.l_start, segment.l_len)) {
>  		perror("fallocate");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/pwrite.c b/io/pwrite.c
> index 1c28612f3bd6..995f6ece8384 100644
> --- a/io/pwrite.c
> +++ b/io/pwrite.c
> @@ -295,6 +295,7 @@ pwrite_f(
>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (tmp < 0) {
>  				printf(_("non-numeric bsize -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			bsize = tmp;
> @@ -333,6 +334,7 @@ pwrite_f(
>  			skip = cvtnum(fsblocksize, fssectsize, optarg);
>  			if (skip < 0) {
>  				printf(_("non-numeric skip -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -340,6 +342,7 @@ pwrite_f(
>  			seed = strtoul(optarg, &sp, 0);
>  			if (!sp || sp == optarg) {
>  				printf(_("non-numeric seed -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -355,6 +358,7 @@ pwrite_f(
>  			if (!sp || sp == optarg) {
>  				printf(_("non-numeric vector count == %s\n"),
>  					optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -369,11 +373,13 @@ pwrite_f(
>  			zeed = strtoul(optarg, &sp, 0);
>  			if (!sp || sp == optarg) {
>  				printf(_("non-numeric seed -- %s\n"), optarg);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
>  		default:
>  			/* Handle ifdef'd-out options above */
> +			exitcode = 1;
>  			if (c != '?')
>  				printf(_("%s: command -%c not supported\n"), argv[0], c);
>  			else
> @@ -381,28 +387,38 @@ pwrite_f(
>  			return 0;
>  		}
>  	}
> -	if (((skip || dflag) && !infile) || (optind != argc - 2))
> +	if (((skip || dflag) && !infile) || (optind != argc - 2)) {
> +		exitcode = 1;
>  		return command_usage(&pwrite_cmd);
> -	if (infile && direction != IO_FORWARD)
> +	}
> +	if (infile && direction != IO_FORWARD) {
> +		exitcode = 1;
>  		return command_usage(&pwrite_cmd);
> +	}
>  	offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (offset < 0) {
>  		printf(_("non-numeric offset argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
>  	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (count < 0) {
>  		printf(_("non-numeric length argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> -	if (alloc_buffer(bsize, uflag, seed) < 0)
> +	if (alloc_buffer(bsize, uflag, seed) < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	c = IO_READONLY | (dflag ? IO_DIRECT : 0);
> -	if (infile && ((fd = openfile(infile, NULL, c, 0, NULL)) < 0))
> +	if (infile && ((fd = openfile(infile, NULL, c, 0, NULL)) < 0)) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	gettimeofday(&t1, NULL);
>  	switch (direction) {
> @@ -425,20 +441,25 @@ pwrite_f(
>  		total = 0;
>  		ASSERT(0);
>  	}
> -	if (c < 0)
> +	if (c < 0) {
> +		exitcode = 1;
>  		goto done;
> +	}
>  	if (Wflag) {
>  		if (fsync(file->fd) < 0) {
>  			perror("fsync");
> +			exitcode = 1;
>  			goto done;
>  		}
>  	}
>  	if (wflag) {
>  		if (fdatasync(file->fd) < 0) {
>  			perror("fdatasync");
> +			exitcode = 1;
>  			goto done;
>  		}
>  	}
> +
>  	if (qflag)
>  		goto done;
>  	gettimeofday(&t2, NULL);
> diff --git a/io/readdir.c b/io/readdir.c
> index 2cb897736faf..8ac3f988ac2f 100644
> --- a/io/readdir.c
> +++ b/io/readdir.c
> @@ -151,18 +151,22 @@ readdir_f(
>  			verbose = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&readdir_cmd);
>  		}
>  	}
>  
>  	dfd = dup(file->fd);
> -	if (dfd < 0)
> -		return -1;
> +	if (dfd < 0) {
> +		exitcode = 1;
> +		return 0;
> +	}
>  
>  	dir = fdopendir(dfd);
>  	if (!dir) {
>  		close(dfd);
> -		return -1;
> +		exitcode = 1;
> +		return 0;
>  	}
>  
>  	if (offset == -1) {
> diff --git a/io/reflink.c b/io/reflink.c
> index 26eb2e32442d..8e4f389949be 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -63,6 +63,7 @@ dedupe_ioctl(
>  		error = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
>  		if (error) {
>  			perror("XFS_IOC_FILE_EXTENT_SAME");
> +			exitcode = 1;
>  			goto done;
>  		}
>  		if (info->status < 0) {
> @@ -117,34 +118,42 @@ dedupe_f(
>  			quiet_flag = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&dedupe_cmd);
>  		}
>  	}
> -	if (optind != argc - 4)
> +	if (optind != argc - 4) {
> +		exitcode = 1;
>  		return command_usage(&dedupe_cmd);
> +	}
>  	infile = argv[optind];
>  	optind++;
>  	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (soffset < 0) {
>  		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
>  	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (doffset < 0) {
>  		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
>  	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (count < 0) {
>  		printf(_("non-positive length argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  	fd = openfile(infile, NULL, IO_READONLY, 0, NULL);
> -	if (fd < 0)
> +	if (fd < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	gettimeofday(&t1, NULL);
>  	total = dedupe_ioctl(fd, soffset, doffset, count, &ops);
> @@ -238,11 +247,14 @@ reflink_f(
>  			quiet_flag = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&reflink_cmd);
>  		}
>  	}
> -	if (optind != argc - 4 && optind != argc - 1)
> +	if (optind != argc - 4 && optind != argc - 1) {
> +		exitcode = 1;
>  		return command_usage(&reflink_cmd);
> +	}
>  	infile = argv[optind];
>  	optind++;
>  	if (optind == argc)
> @@ -250,29 +262,37 @@ reflink_f(
>  	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (soffset < 0) {
>  		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
>  	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (doffset < 0) {
>  		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
>  	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
>  	if (count < 0) {
>  		printf(_("non-positive length argument -- %s\n"), argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  clone_all:
>  	fd = openfile(infile, NULL, IO_READONLY, 0, NULL);
> -	if (fd < 0)
> +	if (fd < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	gettimeofday(&t1, NULL);
>  	total = reflink_ioctl(fd, soffset, doffset, count, &ops);
> -	if (ops == 0 || quiet_flag)
> +	if (ops == 0)
> +		goto done;
> +
> +	if (quiet_flag)
>  		goto done;
>  	gettimeofday(&t2, NULL);
>  	t2 = tsub(t2, t1);
> diff --git a/io/resblks.c b/io/resblks.c
> index 0dbec0957658..a93b14ff48e5 100644
> --- a/io/resblks.c
> +++ b/io/resblks.c
> @@ -24,15 +24,18 @@ resblks_f(
>  		blks = cvtnum(file->geom.blocksize, file->geom.sectsize, argv[1]);
>  		if (blks < 0) {
>  			printf(_("non-numeric argument -- %s\n"), argv[1]);
> +			exitcode = 1;
>  			return 0;
>  		}
>  		res.resblks = blks;
>  		if (xfsctl(file->name, file->fd, XFS_IOC_SET_RESBLKS, &res) < 0) {
>  			perror("XFS_IOC_SET_RESBLKS");
> +			exitcode = 1;
>  			return 0;
>  		}
>  	} else if (xfsctl(file->name, file->fd, XFS_IOC_GET_RESBLKS, &res) < 0) {
>  		perror("XFS_IOC_GET_RESBLKS");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	printf(_("reserved blocks = %llu\n"),
> diff --git a/io/seek.c b/io/seek.c
> index 59ba1cfd1db3..6734ecb5691a 100644
> --- a/io/seek.c
> +++ b/io/seek.c
> @@ -120,15 +120,20 @@ seek_f(
>  			startflag = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&seek_cmd);
>  		}
>  	}
> -	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) || optind != argc - 1)
> +	if (!(flag & (SEEK_DFLAG | SEEK_HFLAG)) || optind != argc - 1) {
> +		exitcode = 1;
>  		return command_usage(&seek_cmd);
> +	}
>  
>  	start = offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> -	if (offset < 0)
> +	if (offset < 0) {
> +		exitcode = 1;
>  		return command_usage(&seek_cmd);
> +	}
>  
>  	/*
>  	 * check to see if the offset is a data or hole entry and
> @@ -174,9 +179,10 @@ found_hole:
>  	for (c = 0; flag; c++) {
>  		if (offset == -1) {
>  			/* print error or eof if the only entry */
> -			if (errno != ENXIO || c == 0 )
> +			if (errno != ENXIO || c == 0 ) {
>  				seek_output(startflag, seekinfo[current].name,
>  					    start, offset);
> +			}
>  			return 0;	/* stop on error or EOF */
>  		}
>  
> diff --git a/io/sendfile.c b/io/sendfile.c
> index 68e607f1b32b..ff012c81042d 100644
> --- a/io/sendfile.c
> +++ b/io/sendfile.c
> @@ -88,6 +88,7 @@ sendfile_f(
>  			if (fd < 0 || fd >= filecount) {
>  				printf(_("value %d is out of range (0-%d)\n"),
>  					fd, filecount-1);
> +				exitcode = 1;
>  				return 0;
>  			}
>  			break;
> @@ -95,22 +96,28 @@ sendfile_f(
>  			infile = optarg;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&sendfile_cmd);
>  		}
>  	}
> -	if (infile && fd != -1)
> +	if (infile && fd != -1) {
> +		exitcode = 1;
>  		return command_usage(&sendfile_cmd);
> +	}
>  
>  	if (!infile)
>  		fd = filetable[fd].fd;
> -	else if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0)
> +	else if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0) {
> +		exitcode = 1;
>  		return 0;
> +	}
>  
>  	if (optind == argc - 2) {
>  		offset = cvtnum(blocksize, sectsize, argv[optind]);
>  		if (offset < 0) {
>  			printf(_("non-numeric offset argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			goto done;
>  		}
>  		optind++;
> @@ -118,6 +125,7 @@ sendfile_f(
>  		if (count < 0) {
>  			printf(_("non-numeric length argument -- %s\n"),
>  				argv[optind]);
> +			exitcode = 1;
>  			goto done;
>  		}
>  	} else {
> @@ -125,6 +133,7 @@ sendfile_f(
>  
>  		if (fstat(fd, &stat) < 0) {
>  			perror("fstat");
> +			exitcode = 1;
>  			goto done;
>  		}
>  		count = stat.st_size;
> @@ -132,8 +141,11 @@ sendfile_f(
>  
>  	gettimeofday(&t1, NULL);
>  	c = send_buffer(offset, count, fd, &total);
> -	if (c < 0)
> +	if (c < 0) {
> +		exitcode = 1;
>  		goto done;
> +	}
> +
>  	if (qflag)
>  		goto done;
>  	gettimeofday(&t2, NULL);
> diff --git a/io/shutdown.c b/io/shutdown.c
> index 052d3def1d4a..3c29ea790643 100644
> --- a/io/shutdown.c
> +++ b/io/shutdown.c
> @@ -24,12 +24,14 @@ shutdown_f(
>  			flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&shutdown_cmd);
>  		}
>  	}
>  
>  	if ((xfsctl(file->name, file->fd, XFS_IOC_GOINGDOWN, &flag)) < 0) {
>  		perror("XFS_IOC_GOINGDOWN");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/stat.c b/io/stat.c
> index d125a0f78539..5f513e0ddfc8 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -137,15 +137,19 @@ stat_f(
>  			verbose = 1;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&stat_cmd);
>  		}
>  	}
>  
> -	if (raw && verbose)
> +	if (raw && verbose) {
> +		exitcode = 1;
>  		return command_usage(&stat_cmd);
> +	}
>  
>  	if (fstat(file->fd, &st) < 0) {
>  		perror("fstat");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> @@ -185,6 +189,7 @@ statfs_f(
>  	printf(_("fd.path = \"%s\"\n"), file->name);
>  	if (platform_fstatfs(file->fd, &st) < 0) {
>  		perror("fstatfs");
> +		exitcode = 1;
>  	} else {
>  		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
>  		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
> @@ -200,6 +205,7 @@ statfs_f(
>  	ret = -xfrog_geometry(file->fd, &fsgeo);
>  	if (ret) {
>  		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
> +		exitcode = 1;
>  	} else {
>  		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
>  		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> @@ -216,6 +222,7 @@ statfs_f(
>  	}
>  	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
>  		perror("XFS_IOC_FSCOUNTS");
> +		exitcode = 1;
>  	} else {
>  		printf(_("counts.freedata = %llu\n"),
>  			(unsigned long long) fscounts.freedata);
> @@ -321,6 +328,7 @@ statx_f(
>  				if (!p || p == optarg) {
>  					printf(
>  				_("non-numeric mask -- %s\n"), optarg);
> +					exitcode = 1;
>  					return 0;
>  				}
>  			}
> @@ -340,6 +348,7 @@ statx_f(
>  			atflag |= AT_STATX_DONT_SYNC;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&statx_cmd);
>  		}
>  	}
> @@ -350,8 +359,10 @@ statx_f(
>  	memset(&stx, 0xbf, sizeof(stx));
>  	if (_statx(file->fd, "", atflag | AT_EMPTY_PATH, mask, &stx) < 0) {
>  		perror("statx");
> +		exitcode = 1;
>  		return 0;
>  	}
> +	exitcode = 0;
>  
>  	if (raw)
>  		return dump_raw_statx(&stx);
> diff --git a/io/sync_file_range.c b/io/sync_file_range.c
> index 30bbc93d55a1..94285c22f829 100644
> --- a/io/sync_file_range.c
> +++ b/io/sync_file_range.c
> @@ -46,6 +46,7 @@ sync_range_f(
>  			sync_mode = SYNC_FILE_RANGE_WRITE;
>  			break;
>  		default:
> +			exitcode = 1;
>  			return command_usage(&sync_range_cmd);
>  		}
>  	}
> @@ -54,13 +55,16 @@ sync_range_f(
>  	if (!sync_mode)
>  		sync_mode = SYNC_FILE_RANGE_WRITE;
>  
> -	if (optind != argc - 2)
> +	if (optind != argc - 2) {
> +		exitcode = 1;
>  		return command_usage(&sync_range_cmd);
> +	}
>  	init_cvtnum(&blocksize, &sectsize);
>  	offset = cvtnum(blocksize, sectsize, argv[optind]);
>  	if (offset < 0) {
>  		printf(_("non-numeric offset argument -- %s\n"),
>  			argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  	optind++;
> @@ -68,11 +72,13 @@ sync_range_f(
>  	if (length < 0) {
>  		printf(_("non-numeric length argument -- %s\n"),
>  			argv[optind]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  	if (sync_file_range(file->fd, offset, length, sync_mode) < 0) {
>  		perror("sync_file_range");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/truncate.c b/io/truncate.c
> index 5c3f54c4cdf8..1d049194d380 100644
> --- a/io/truncate.c
> +++ b/io/truncate.c
> @@ -23,11 +23,13 @@ truncate_f(
>  	offset = cvtnum(blocksize, sectsize, argv[1]);
>  	if (offset < 0) {
>  		printf(_("non-numeric truncate argument -- %s\n"), argv[1]);
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  	if (ftruncate(file->fd, offset) < 0) {
>  		perror("ftruncate");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	return 0;
> diff --git a/io/utimes.c b/io/utimes.c
> index 40117472e873..39127b84a90c 100644
> --- a/io/utimes.c
> +++ b/io/utimes.c
> @@ -36,17 +36,20 @@ utimes_f(
>  	result = timespec_from_string(argv[1], argv[2], &t[0]);
>  	if (result) {
>  		fprintf(stderr, "Bad value for atime\n");
> +		exitcode = 1;
>  		return 0;
>  	}
>  	result = timespec_from_string(argv[3], argv[4], &t[1]);
>  	if (result) {
>  		fprintf(stderr, "Bad value for mtime\n");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
>  	/* Call futimens to update time. */
>  	if (futimens(file->fd, t)) {
>  		perror("futimens");
> +		exitcode = 1;
>  		return 0;
>  	}
>  
> -- 
> 2.26.0.rc2
> 
