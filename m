Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ED9246BB9
	for <linux-xfs@vger.kernel.org>; Mon, 20 Oct 2025 05:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760937314; cv=none; b=LGfTVl7W9+QH89VY65eXjaeXtVFOPx+FZwSGwTAwRxjBniO4k39GXhc+wUTppMpy0PhKoTT/fCy4OPBB9qhoAjr69y+Ane6JVBbtSzs2NFNnexLHhXsU9dpK79w3eUx+Rwq9lVK04DepCwZOvR1FEHqWE1F9s0beSUP9ehM9Qto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760937314; c=relaxed/simple;
	bh=Z6+ImmeDV0LNyW8fUWfwOI5ejYfngJeHisrNK+MFll4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YMZg0SwtFTXkag50gqSdlr8wVgI0nZzGbdigXjYDNgT+U7GMDtKcNc7KXlUIDrPsf7ClpsAVf+wY6lY0orGNaYawxau7CXSoEeIr4lF7yzvtdcVTC3OmRcdJwHvDrOOI7RkrhVWOPR6F0wUqO7XXtAR1FnvF4l5LhM0GSoGqE10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PgSBtKMi; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgSBtKMi"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so53544715ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 19 Oct 2025 22:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760937311; x=1761542111; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=to20Fz69HzaFXBLRP91Nt7sJNBzjM9vSXs8ayG2MjmU=;
        b=PgSBtKMiBz86yRJ1rga9+tsngyznix8Vj6BZM688ZOvWt3rk3Zn00IjoBGSzoMQNUd
         gaUWsJBPWfzfrUye7PF626pSw+4YNmiUGxTmBomji2HKwExXIYoUrnbMVzrlzXTl6YOl
         fy6EmHhkiTQoxmRXzlc4wrTk7Tt9vgKiV2O7AKNTlDl9RtIoaPWNdEY0L6zBtt/6pFH3
         tMCT8zs/ZF3mXdKXK6YWMZoMVoiLZ2NnRR2CcLQWXocnnXB4XVvuOIzQd/tGGyxaSF5u
         HYZJ8oeRR5OTgb5Ibl46b8BN3u7sg4HF4Tmv6qGO40/Efcs5x4DBAxF25X18cyzAM/Qz
         K6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760937311; x=1761542111;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=to20Fz69HzaFXBLRP91Nt7sJNBzjM9vSXs8ayG2MjmU=;
        b=p+qFs9BRPza6M6N/g1zrFE1e3V5w4unNqtMLkvadnxfziiWaBYYzeJeRMwTdE97jbb
         WbK3ou6Af3c0KJOb/aXRDV6tlr/33HRHh80WnJF8fjP9LJUJ+hDUoMUrC9dgn3Bw3e2O
         xWR4vjos9Cncu6FF0YAyuBjJZfsh7z4fx5iX+CFZsqSNy8EsPEBhHvtBfenuQQk4+TRZ
         PPe2ILwxBbjibhUN/DITcfS/ZOFHGHsBo/C4QuyTz7PyxMSWoEISZHsfqj9phMQr6o2x
         Q4qIc7PMcVrYZXwSkdlFIks+xPoHb5tYkCh7FNW1TGqJ+WTwJ7q0PzQa8C7QEF//8J8D
         GVfA==
X-Forwarded-Encrypted: i=1; AJvYcCW5FKASu3uOwJTUZZnZSXETJP2i1/P2rMZn7c/tPrXC2uVhf2fBYMvaqd28bsDam/vusbRYp4ozCYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzciiyGNCRFD/d3FAYAnv5SIqsMZcMv4NHUti4w6peZvdtCxss9
	nu3Ekac6uosAYVnLGpzFRLGol6jpUEQKhb/J/84ACfGZmYHQcdCkOynU
X-Gm-Gg: ASbGncucTq2PfzsLVqTV/OniLJC/PMp3IG32u1wwVWp9VGWFuK6LET+iGxbMasHZTqY
	OvBDNVwuvaMeuTeXZK99j033WHPNZrHWDXFTCZd0XJP1kamhkUjffneWUlljjhYdrQ8FODVlGjf
	MGELc8T3iC4i8BGMahpq9TX8uS/Uer/pgfgSapnDBMp2Do8UxFSHothAk/70Fz4nzFoaTom8Nar
	CMWTv714geB8Enp36PhSu8USgqcMNMsvMHss/qCiQ6VFDHGZB1bzxGyc2ePoAxx0qdI2iKuBGDI
	DqWUT+KaCvATsAsmnGFWAMzVtrnIdtbynLO3JWXiH+wOLsI/o6CR87KPOuRUgsYRJx49iu9FwSD
	MsYy+quOK1VYSiLQEI3PCQQ4VDzmb728K0qzSDT4Eg1KRJ1Za7drRiVZVakqyEY0WSC4QU4lBUV
	GTBWgt+ZHYZ9eoZlXLfZjUgwyApOL+XH2n7O5gsBXwjO1kRFQ=
X-Google-Smtp-Source: AGHT+IFOVPrFs4XDwOz9Wf7H8WI7AAA1vGzGWjLg2Hnv7m8Mqy6Gk9sdtib3KWNcPHTmSYnf4M49Ew==
X-Received: by 2002:a17:903:240a:b0:25e:37ed:d15d with SMTP id d9443c01a7336-290c99b11femr143543635ad.0.1760937311136;
        Sun, 19 Oct 2025 22:15:11 -0700 (PDT)
Received: from [192.168.50.88] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29247219457sm68958645ad.113.2025.10.19.22.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Oct 2025 22:15:10 -0700 (PDT)
Message-ID: <07fa286c-23b1-4ca7-9019-47631e2af908@gmail.com>
Date: Mon, 20 Oct 2025 13:15:07 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] common/zoned: add helpers for creation and
 teardown of zloop devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
 Hans Holmberg <Hans.Holmberg@wdc.com>, linux-xfs@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
References: <20251017055008.672621-1-johannes.thumshirn@wdc.com>
 <20251017055008.672621-3-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251017055008.672621-3-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/10/25 13:50, Johannes Thumshirn wrote:
> Add _create_zloop, _destroy_zloop and _find_next_zloop helper functions
> for creating destroying and finding the next free zloop device.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   common/zoned | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 53 insertions(+)
> 
> diff --git a/common/zoned b/common/zoned
> index 41697b08..e2f5969c 100644
> --- a/common/zoned
> +++ b/common/zoned
> @@ -45,3 +45,56 @@ _require_zloop()
>   	    _notrun "This test requires zoned loopback device support"
>       fi
>   }
> +
> +_find_next_zloop()
> +{
> +    id=0
> +
> +    while true; do
> +        if [[ ! -b "/dev/zloop$id" ]]; then
> +            break
> +        fi
> +        id=$((id + 1))
> +    done
> +
> +    echo "$id"
> +}
> +
> +# Create a zloop device
> +# usage: _create_zloop <base_dir> <zone_size> <nr_conv_zones>
> +_create_zloop()
> +{
> +    local id="$(_find_next_zloop)"
> +
> +    if [ -n "$1" ]; then
> +        local zloop_base="$1"
> +    else
> +        local zloop_base="/var/local/zloop"
> +    fi
> +
> +    if [ -n "$2" ]; then
> +        local zone_size=",zone_size_mb=$2"
> +    fi
> +
> +    if [ -n "$3" ]; then
> +        local conv_zones=",conv_zones=$3"
> +    fi
> +
> +    mkdir -p "$zloop_base/$id"
> +
> +    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones"
> +
> +    echo "$zloop_args" > /dev/zloop-control || \
> +        _fail "cannot create zloop device"
> +
> +    echo "/dev/zloop$id"
> +}
> +
> +_destroy_zloop() {
> +    local zloop="$1"
> +
> +    test -b "$zloop" || return
> +    local id=$(echo $zloop | grep -oE '[0-9]+$')
> +
> +    echo "remove id=$id" > /dev/zloop-control
> +}


Reviewed-by: Anand Jain <asj@kernel.org>

Looks good.

Small nit: The function bracketing is inconsistent in this patch and in 
the file as well. We should fix this separately.




