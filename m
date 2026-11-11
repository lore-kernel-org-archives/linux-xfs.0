Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411189;
	b=cclx8UfM8KiArMNclD5NjRTxko9yRB6LJzHznoL2XfEHxWfab1lyEz9Qz5V4CPcc799W
	 cCMzyR9p15E8P6Jdsm4jEdFVD5zjgRTjJiR0yrsL0eUsEezQeO/KeLN3rG68i8MFu8wCI
	 PLvIcwkHMktuqHTSB+9H+1wWR5DW6nSMzZs0SBWO0bEakesoBrkZ4ZHteQFvhL+dMHrGD
	 zLU0QZTLW9Jzklnwb3OLbFSy9kpGwK+xGAGe3ui93R/zW28vkGqzZV6YrFQhKCCCkwdjs
	 TBWgy20a1XWcDRgbDmP8ZP055c0XZYEXCpbdzoFKzUUznf16laRGrgpcEjWRDljDEXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411189;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WRSp26Acz8H5qpkuFnrKZCMQOZdj2lyIV9VHB6zl4q8=;
	b=q+44I1mKBoRzKXBBtpcPWDLFuO1Tmr/epYCUXin/6ICWI0+gvAsWtK+DAGKuA5iOKMVi
	 zKQuJgWqJGJNaaNw0fCbYlyQFbKIQF4GzeUeQxWSh0agiviPlLd9aFAaVdQvkYDlrVVQ+
	 WCcprCA4rIRtp850Oa6EDNyT3mkhj1LJDGBcRIUd6YE3F1CShLiKaP8whsg11jmfxy5PX
	 4W1+jh/9lCoFitIV/3ObyH1b0Nj2yfRlQ1/rQXwVdLBpJw2zG6IPZOglQ+VhA7hxQiU7u
	 rHToGSqnzl6YmELHIHXpyKbGWNw0JK4DiYRQKcB+8m+Sw7wd9y0ElSpTvQQXY636Gdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=sandeen.net;
	spf=pass smtp.mailfrom=sandeen.net;
	dkim=pass header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b="Zi/gJfKc";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=feej6SAa;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27DA606A891
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 15:33:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A27DA606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sandeen.net header.i=@sandeen.net header.a=rsa-sha256 header.s=fm3 header.b=Zi/gJfKc;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=feej6SAa
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E53E87A0282
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 10:33:07 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 11 Nov 2026 10:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1794411187;
	 x=1794497587; bh=WRSp26Acz8H5qpkuFnrKZCMQOZdj2lyIV9VHB6zl4q8=; b=
	Zi/gJfKcsLbG39CszPG6BKoYE/1NthOcRRsKfbhiIG85p3o1zwUMYfiGb1yKQpWd
	t6q5Eitk2Tq9S5GnADz6idCNlIJgcBlBn6YQ3uKtpTf7tyXenk5KzYXfWvqzBfur
	ynX4bMcrujBdJCgujWZo56zU+GloyNxIFb8/SSocqHLD22WUjJFOTKUwsbkF2+xe
	GxMbj98072GquKa4DEO29X30fRkaBp84rbFD6wOdBjj3ScXkGwnsLfD422QYb/+N
	xOANhCpRj+/Dv/8b6PR8IKSO9+99rJSVEYq3EwwZgwxpgG0n+27gkWlcI5pD0xgF
	4hTHqC7CWpu89L9SlfCEqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794411187; x=1794497587; bh=W
	RSp26Acz8H5qpkuFnrKZCMQOZdj2lyIV9VHB6zl4q8=; b=feej6SAaTS3lwBHTR
	3TIAZIoOj3oiy2LepYrdcwfaLG2TN1SSdqq/SCn0abdUqap6jBT+NEztMvRQ1rXD
	lvl5Qv47XGDFCJvuHT5DNEuycA5fzzuqtaXkG26ZLdNLMilRG4WCPaT54ZYsUEl8
	JVwhOZpFVJcGWqnPFcScXDFelRLz+m2iQ9rZc93DfSOt1tTmNmbDwLAJlwM2ucby
	9rIgaaSolxiQKBJPIJUALwaEaUzCyfZOvXdUBYvGKBdgTiiZiGI/QaobGT5IF2+U
	czmDBEQVNEOPh2qrokud543y4uihiH1zZp2aVHy4Bign07drloZ9r40UNSXaEtV5
	GVSXg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794411187; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:mOchecSHfAUJLaP8yW8Y3gUcN2BISTK2SeDqg28oyYBTtRc
	MO4ap7ABX/IjEIVWflb4jUDcmF9hjRS8eZYZvec5DgeRqHYUEX+9nf4m09tJh5Hm
	D078rGacQpJtGoz92wwWxa/qeN4wnGWlQByjxWeed3acWyiT+9AYCjVlaYnS7V/x
	7kbmE4/nnBZzDvFW50mFDYw4yYI0xvN4pdks/CEG2ysLQGAf7msPg4KpH27yQt9j
	HsZY+fubpWFHDwFZMmzGW0UFtiTnABaZZVZs9QjJzhdzK9RppldZdWnUsDwDRgV1
	N23M57SuaLo11vDOlXqli4VeC9zRxraNRsh/Tvg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=content-language,content-transfer-encoding,content-type,date,
	feedback-id,from,in-reply-to,message-id,mime-version,references,
	subject,to,user-agent;
Message-Instance: m=1; h=sha256:s5fC6vxUCmIz/Bz8BzBIgsueJx523B2N+6r95tD9U6k=:vg4axB4V+ypvrl9xCgk26sytyb0X8d0m76ndvBcf9fA=;
X-ME-Sender: <xms:s4r0agjmc4k2Jttz2fd7F41AB-rKT8u8n3K9Mz-qJuc1WA--85jIKQ>
    <xme:s4r0av81BE0RImSaOJlULXNgLaIwvUIqkCrsJbM2JxcyY8wuxrR__XbwgYos3CdQ2
    0mQQLA1OOfB7dqLu7MjR7r0nyksS7UxwZoXeQ4FQxZvWYOBQfOWxiIH>
X-ME-Received: <xmr:s4r0atuChPjO3CId99FQPcz5SCS7f5TkRfuKy7wcl5ThPESnYjgaJLlhx0Fuly7YPAIHokS0n74gdNsVRTBRNQ>
X-ME-Proxy-Cause: dmFkZTGQFheOEx7En8wMm6TxokBOfrwYvm1EFrxIWRB/0QoU0DikQj0vslDnQt9uggPxoL
    rjIfxfEHT9e4J99KiVIQJEoqwKqCNe3x/xidbMgIlFKbGcT6cV5ffp/e5lHEyY6f5cTfN6
    LbolXI+EcaLBOw8f0t6wYV2bdOaowSuezj2vNX21LUhLzOmok1WDA2OL36d5OJBXoOgtuu
    pAbBpVb3N7vVCRLTvjn8J+NSRn03HB+BU4ELGi/BwgBN5UrV6s4pbLet/7IcxYbXf6i6Hb
    zBWkSHH5Q6v0JSU7XZqSG8HvDBeX5XZM2GDOBFfO1JlWnpukLiaCf2A5/rxwn1/FtTdLC7
    5ldrshOXFWDRJG/TAx/3QUOZUhpu0goFX/xxy0JIqWEqo2FyczYCtcEFz0xGw9vUskce8a
    8R8tGVZ8FCb0QoJpqU6lAtCXyZqsLS3FxkSZKMaFPWwmR9ry7sRNLfyokf6nK3WCcUv+d0
    QxttspQEdj8TGx6P5T30FX0vAoxQd9f8X1VROD+Qh84p0h2UAqDZsulc4No+lGmQ4P0c3n
    8nv0+MLs3wc4/eSFBYwXz8y/o5wXlDjDT5dC5Q6nLA01U58bsqmRzlA3QSCw6ZZdUZWvnG
    MQEhUruJOakgmd4vKnAt+59y0aCc0HppBK/Rl6FweVXJzgFEDzfcgWCIj0+g
X-ME-Proxy: <xmx:s4r0amb6VdJrnOtx06dDpe_SRbndwJxtS-4ClAsJyW_X7KkYroodkw>
    <xmx:s4r0ato2wLjejSB_7glWCxc-ZLjghbFARuhLnrc8k3bYjnVk7basTg>
    <xmx:s4r0ar8jwrnYHTxT20J3exi1Apxvdk_nWiQOR55oqMfKUhpIOcjAVg>
    <xmx:s4r0as_b2SiAdCZIwpoDxj8ZYQOVBX-s9f7DoE-zZRAETf-o8b6ajQ>
    <xmx:s4r0aliv9Svz6K0k6zJ8IekQSt6RqYCrYctjR5SYW9jHZRRwPICRDNX0>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 10:33:07 -0500 (EST)
Message-ID: <a5a4ecfb-4f88-4b3c-bbb6-ae6b29730f7e@sandeen.net>
Date: Wed, 11 Nov 2026 09:33:06 -0600
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_admin: remove eval use
To: linux-xfs@vger.kernel.org
References: <20261111151107.3884786-2-aalbersh@kernel.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20261111151107.3884786-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/26 9:11 AM, Andrey Albershteyn wrote:
> The eval is known to cause issues due to the fact that it parses and
> executes strings as code. Let's get rid of it.
> 
> Remove use of eval and instead set a bunch of boolean and value flags.
> These are latter appended to the empty set of positional parameters $@.
> These parameters are not parsed.
> 
> Reported-by: Hazley Samsudin <muhammad_hazley_samsudin_from.tp@tech.gov.sg>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Looks good to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/xfs_admin.sh | 142 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 99 insertions(+), 43 deletions(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 13a876ad8d13..6b2102815cd7 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -7,53 +7,74 @@
>  status=0
>  require_offline=""
>  require_online=""
> -DB_OPTS=""
> -DB_DEV_OPTS=""
> -REPAIR_OPTS=""
> -IO_OPTS=""
> -SPACEMAN_OPTS=""
> -REPAIR_DEV_OPTS=""
> -LOG_OPTS=""
> +have_db=""
> +have_repair=""
> +opt_extflg=""			# -e
> +opt_force=""			# -f
> +opt_log2=""			# -j
> +opt_projid32bit=""		# -p
> +opt_get_label=""		# -l
> +opt_get_uuid=""			# -u
> +opt_cfgfile=""			# -C
> +cfgfile=""
> +opt_set_label=""		# -L
> +set_label=""
> +opt_set_uuid=""			# -U
> +set_uuid=""
> +opt_rtdev=""			# -r
> +rtdev=""
> +repair_tokens=""
> +
>  USAGE="Usage: xfs_admin [-efjlpuV] [-C cfgfile] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
>  
>  while getopts "C:c:efjlL:O:pr:uU:V" c
>  do
>  	case $c in
> -	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
> +	c)	repair_tokens="$repair_tokens lazycount=$OPTARG"
>  		require_offline=1
> +		have_repair=1
>  		;;
> -	C)	DB_OPTS=$DB_OPTS" -c 'makecfg "$OPTARG"'"
> -		SPACEMAN_OPTS=$SPACEMAN_OPTS" -c 'makecfg "$OPTARG"'"
> +	C)	opt_cfgfile=1
> +		cfgfile=$OPTARG
> +		have_db=1
>  		;;
> -	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'"
> +	e)	opt_extflg=1
> +		have_db=1
>  		require_offline=1
>  		;;
> -	f)	DB_OPTS=$DB_OPTS" -f"
> +	f)	opt_force=1
> +		have_db=1
>  		require_offline=1
>  		;;
> -	j)	DB_OPTS=$DB_OPTS" -c 'version log2'"
> +	j)	opt_log2=1
> +		have_db=1
>  		require_offline=1
>  		;;
> -	l)	DB_OPTS=$DB_OPTS" -r -c label"
> -		IO_OPTS=$IO_OPTS" -r -c label"
> +	l)	opt_get_label=1
> +		have_db=1
>  		;;
> -	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
> -		IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'"
> +	L)	opt_set_label=1
> +		set_label=$OPTARG
> +		have_db=1
>  		;;
> -	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG"
> +	O)	repair_tokens="$repair_tokens $OPTARG"
>  		require_offline=1
> +		have_repair=1
>  		;;
> -	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'"
> +	p)	opt_projid32bit=1
> +		have_db=1
>  		require_offline=1
>  		;;
> -	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'"
> -		DB_DEV_OPTS=" -R '$OPTARG'"
> +	r)	opt_rtdev=1
> +		rtdev=$OPTARG
>  		require_offline=1
>  		;;
> -	u)	DB_OPTS=$DB_OPTS" -r -c uuid"
> -		IO_OPTS=$IO_OPTS" -r -c fsuuid"
> +	u)	opt_get_uuid=1
> +		have_db=1
>  		;;
> -	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'"
> +	U)	opt_set_uuid=1
> +		set_uuid=$OPTARG
> +		have_db=1
>  		require_offline=1
>  		;;
>  	V)	xfs_db -p xfs_admin -V
> @@ -65,50 +86,85 @@ do
>  		;;
>  	esac
>  done
> -set -- extra $@
> +set -- extra "$@"
>  shift $OPTIND
> +device=$1
> +logdev=$2
> +
> +# We use a bunch of opt_* flags here instead of crafting argument strings
> +# directly in the getopts loop above. This is because passing such strings
> +# to eval could cause command injection.
> +#
> +# As we cannot use arrays in POSIX, instead we resort to using the positional
> +# parameters ($@). Before calling any of the xfs_* utilities we reset $@ to an
> +# empty set with "set --". Then, based on the flags parsed above, we append all
> +# necessary arguments. This way each argument is passed verbatim, without being
> +# re-parsed or word-split by the shell.
>  case $# in
>  	1|2)
> -		if mntpt="$(findmnt -t xfs -f -n -o TARGET "$1" 2>/dev/null)"; then
> +		if mntpt="$(findmnt -t xfs -f -n -o TARGET "$device" 2>/dev/null)"; then
>  			# filesystem is mounted
>  			if [ -n "$require_offline" ]; then
> -				echo "$1: filesystem is mounted."
> +				echo "$device: filesystem is mounted."
>  				exit 2
>  			fi
>  
> -			if [ -n "$SPACEMAN_OPTS" ]; then
> -				eval xfs_spaceman -p xfs_admin $SPACEMAN_OPTS "$mntpt"
> +			have_io=""
> +			if [ -n "$opt_get_label" ] || [ -n "$opt_set_label" ] || \
> +			   [ -n "$opt_get_uuid" ]; then
> +				have_io=1
> +			fi
> +
> +			if [ -n "$opt_cfgfile" ]; then
> +				xfs_spaceman -p xfs_admin -c "makecfg $cfgfile" "$mntpt"
>  				res=$?
>  				test $res -ne 0 && exit $res
> -				test -n "$IO_OPTS" || exit $res
> +				test -n "$have_io" || exit $res
>  			fi
>  
> -			if [ -n "$IO_OPTS" ]; then
> -				eval xfs_io -p xfs_admin $IO_OPTS "$mntpt"
> -				exit $?
> +			if [ -n "$have_io" ]; then
> +				set --
> +				[ -n "$opt_get_label" ] && set -- "$@" -r -c label
> +				[ -n "$opt_set_label" ] && set -- "$@" -c "label -s $set_label"
> +				[ -n "$opt_get_uuid" ] && set -- "$@" -r -c fsuuid
> +				exec xfs_io -p xfs_admin "$@" "$mntpt"
>  			fi
>  		fi
>  
>  		# filesystem is not mounted
>  		if [ -n "$require_online" ]; then
> -			echo "$1: filesystem is not mounted"
> +			echo "$device: filesystem is not mounted"
>  			exit 2
>  		fi
>  
> -		# Pick up the log device, if present
> -		if [ -n "$2" ]; then
> -			LOG_OPTS=" -l '$2'"
> -		fi
> -
> -		if [ -n "$DB_OPTS" ]
> +		if [ -n "$have_db" ]
>  		then
> -			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_DEV_OPTS $DB_OPTS "$1"
> +			set --
> +			[ -n "$logdev" ] && set -- "$@" -l "$logdev"
> +			[ -n "$opt_rtdev" ] && set -- "$@" -R "$rtdev"
> +			[ -n "$opt_cfgfile" ] && set -- "$@" -c "makecfg $cfgfile"
> +			[ -n "$opt_extflg" ] && set -- "$@" -c "version extflg"
> +			[ -n "$opt_force" ] && set -- "$@" -f
> +			[ -n "$opt_log2" ] && set -- "$@" -c "version log2"
> +			[ -n "$opt_get_label" ] && set -- "$@" -r -c label
> +			[ -n "$opt_set_label" ] && set -- "$@" -c "label $set_label"
> +			[ -n "$opt_projid32bit" ] && set -- "$@" -c "version projid32bit"
> +			[ -n "$opt_get_uuid" ] && set -- "$@" -r -c uuid
> +			[ -n "$opt_set_uuid" ] && set -- "$@" -c "uuid $set_uuid"
> +			xfs_db -x -p xfs_admin "$@" "$device"
>  			status=$?
>  		fi
> -		if [ -n "$REPAIR_OPTS" ]
> +		if [ -n "$have_repair" ]
>  		then
>  			echo "Running xfs_repair to upgrade filesystem."
> -			eval xfs_repair $LOG_OPTS $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
> +			set --
> +			[ -n "$logdev" ] && set -- "$@" -l "$logdev"
> +			[ -n "$opt_rtdev" ] && set -- "$@" -r "$rtdev"
> +			for token in $repair_tokens
> +			do
> +				set -- "$@" -c "$token"
> +			done
> +			xfs_repair "$@" "$device"
>  			status=`expr $? + $status`
>  		fi
>  		;;

