Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35510 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751078AbdGZXxB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jul 2017 19:53:01 -0400
Subject: Re: [PATCH 7/7] mkfs: save user input values into opts
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-8-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b9dca0fe-be1f-258e-8e55-0ecff3669139@sandeen.net>
Date: Wed, 26 Jul 2017 18:53:00 -0500
MIME-Version: 1.0
In-Reply-To: <20170720092932.32580-8-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 7/20/17 4:29 AM, Jan Tulak wrote:
> Save the parsed values from users into the opts table. This will ensure that
> the user values gets there and are validated, but we are not yet using them for
> anything - the usage makes a lot of changes through the code, so it is better
> if that is separated into smaller chunks.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

This seems reasonable, but AFAICT nothing uses the set values yet,
right?  As such I'll probably hold off on merging it until somethig
makes use of the result... i.e. merge it (and the prior patch)
along with later patches which make use of the stored values.

Also, questions below.

>  				case I_PROJID32BIT:
>  					sb_feat.projid16bit =
>  						!getnum(value, &opts[OPT_I],
>  							I_PROJID32BIT);
> +					set_conf_val(OPT_I, I_PROJID32BIT,
> +						     sb_feat.projid16bit);
>  					break;

why isn't this just:

sb_feat.projid16bit = parse_conf_val(OPT_I, I_PROJID32BIT, value) ?


> @@ -1812,34 +1843,48 @@ main(
>  					xi.logname = logfile;
>  					ldflag = 1;
>  					loginternal = 0;
> +					set_conf_val(OPT_L, L_NAME, 1);
> +					set_conf_val(OPT_L, L_DEV, 1);

Hm, ok, maybe these subopts will collapse into one some day?

>  					break;
>  				case L_VERSION:
>  					sb_feat.log_version =
> -						getnum(value, &opts[OPT_L],
> -								L_VERSION);
> +						parse_conf_val(OPT_L,
> +							       L_VERSION,
> +							       value);
>  					lvflag = 1;
> +					set_conf_val(OPT_L, L_VERSION,
> +						     sb_feat.log_version);
>  					break;

wait, didn't parse_conf_val already set a value into OPT_L, L_VERSION?


>  				case M_FINOBT:
> -					sb_feat.finobt = getnum(
> -						value, &opts[OPT_M], M_FINOBT);
> +					sb_feat.finobt =
> +						parse_conf_val(OPT_M, M_FINOBT,
> +							       value);
> +					set_conf_val(OPT_M, M_FINOBT,
> +						     sb_feat.finobt);

Same here, hasn't OPT_M, M_FINOBT's value already been set by the parse
call?


> @@ -1920,14 +1977,17 @@ main(
>  					} else {
>  						sb_feat.dir_version =
>  							getnum(value,
> -							       &opts[OPT_N],
> -							       N_VERSION);
> +								&opts[OPT_N],
> +								N_VERSION);
>  					}
>  					nvflag = 1;
> +					set_conf_val(OPT_N, N_VERSION,
> +						     sb_feat.dir_version);

shouldn't this be in the else clause?  We didn't necessarily set a
version number, right?  Also, should the ci state be stored as well?
i.e.

    case N_VERSION:
                                        value = getstr(value, &nopts, N_VERSION);
                                        if (!strcasecmp(value, "ci")) {
                                                /* ASCII CI mode */
                                                sb_feat.nci = true;
						/* is this in the opts table anywhere? */
                                        } else {
                                                sb_feat.dir_version =
                                                        parse_conf_val(OPT_N,
								       N_VERSION,
								       value);
                                        }
                                        nvflag = 1;
                                        break;


>  					break;
>  				case N_FTYPE:
> -					sb_feat.dirftype = getnum(value,
> -						&opts[OPT_N], N_FTYPE);
> +					sb_feat.dirftype =
> +						parse_conf_val(OPT_N, N_FTYPE,
> +							       value);
>  					break;
>  				default:
>  					unknown('n', value);
> @@ -1957,25 +2017,30 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case R_EXTSIZE:
> -					rtextbytes = getnum(value,
> -						&opts[OPT_R], R_EXTSIZE);
> +					rtextbytes = parse_conf_val(OPT_R,
> +								    R_EXTSIZE,
> +								    value);
>  					break;
>  				case R_FILE:
> -					xi.risfile = getnum(value,
> -						&opts[OPT_R], R_FILE);
> +					xi.risfile = parse_conf_val(OPT_R,
> +								    R_FILE,
> +								    value);
>  					break;
>  				case R_NAME:
>  				case R_DEV:
>  					xi.rtname = getstr(value, &opts[OPT_R],
>  							   R_NAME);
> +					set_conf_val(OPT_R, R_NAME, 1);
> +					set_conf_val(OPT_R, R_DEV, 1);
>  					break;
>  				case R_SIZE:
> -					rtbytes = getnum(value, &opts[OPT_R],
> -								R_SIZE);
> +					rtbytes = parse_conf_val(OPT_R, R_SIZE,
> +								 value);
>  					break;
>  				case R_NOALIGN:
> -					norsflag = getnum(value, &opts[OPT_R],
> -								R_NOALIGN);
> +					norsflag = parse_conf_val(OPT_R,
> +								  R_NOALIGN,
> +								  value);
>  					break;
>  				default:
>  					unknown('r', value);
> @@ -1996,12 +2061,14 @@ main(
>  						conflict('s', subopts,
>  							 S_SECTSIZE,
>  							 S_SECTLOG);
> -					sectorlog = getnum(value, &opts[OPT_S],
> -							   S_SECTLOG);
> +					sectorlog = parse_conf_val(OPT_S,
> +								   S_SECTLOG,
> +								   value);
>  					lsectorlog = sectorlog;
>  					sectorsize = 1 << sectorlog;
>  					lsectorsize = sectorsize;
>  					lslflag = slflag = 1;
> +					set_conf_val(OPT_S, S_LOG, sectorsize);

Is this right?  S_LOG is the log of the sectorsize, right, not the sector size
itself.  Do S_SIZE & S_SECTSIZE need to be stored as well?

>  					break;
>  				case S_SIZE:
>  				case S_SECTSIZE:
> @@ -2009,13 +2076,16 @@ main(
>  						conflict('s', subopts,
>  							 S_SECTLOG,
>  							 S_SECTSIZE);
> -					sectorsize = getnum(value,
> -						&opts[OPT_S], S_SECTSIZE);
> +					sectorsize = parse_conf_val(OPT_S,
> +								    S_SECTSIZE,
> +								    value);
>  					lsectorsize = sectorsize;
>  					sectorlog =
>  						libxfs_highbit32(sectorsize);
>  					lsectorlog = sectorlog;
>  					lssflag = ssflag = 1;
> +					set_conf_val(OPT_S,
> +						     S_SIZE, sectorlog);

same questions here - this looks wrong, and other values not stored, do
they need to be?

>  					break;
>  				default:
>  					unknown('s', value);
> 
