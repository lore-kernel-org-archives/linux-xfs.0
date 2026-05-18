Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519913F58F1
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115442; cv=none; b=W+XX+Wx8ehJfRLQ8mR+d3bJOKtAvuqAxL543qSiyy112eYP59yD9rh/YZr9IkPfjpnk7DzqkLa65hT7uIfio6rJR0+O9FPmeq4bw+kh5itRSksH5U9Vhc6V7WkHz85LvpV/Gajq97IqXvoYzsr1swBNzefHAz9qzGAWFqp61Wj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115442; c=relaxed/simple;
	bh=DyV8E3gxpcSupU2HjznTUlS9YPVeCW8iPycUi9wK0EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Id+zgbUN4fDQB2QybSYi7SBAEizQw/e9KQkDWmFkfYQmxpSMB7IHMQ49cFu10t/Rtz5KY+A+6dNdzR+3gY2q3RyR6yYZ+QGBYp7SuZ6iUVFPtQY7lO+q2n2yRppR9yFLBith1nhE+/+5Da+LH3nn39zzrIdksCILTIAwjFheTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4+tDHig; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4+tDHig"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82748257f5fso2132540b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 07:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779115441; x=1779720241; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aw3Z5TVg60gqBwRTovyIOoXICrBGxM4+/44g78bnGc4=;
        b=M4+tDHigKh0ivz8gpaqr/o19kEk9bNx2U3Mj4EY08txi1IAUE6OR+8wwYW03j3GRTy
         h0RB1/Vq6EW4E+FQcM4zykvp5Fjt6u5kM7aigRyTme6flDmDDD98GjYhW1S0Cz9ki2dI
         pokBK9vGiah9n7hQM7L6drNHDw+tHDmbJyrX/HSQe9df80Hw3vfX8OdiNpxi1AGACbcM
         PR3jVsBI1IRPoJfVyaM6jwyDDVs3VqsmX6ktFeZLtjt2JekQlRNxl31pzq48IfidX0fJ
         iWogToX+yW3IOalChrMvvafe+OHhayufbWju0muC89ze2IkYf25dw7VtgXxcEs5H3303
         Al+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779115441; x=1779720241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aw3Z5TVg60gqBwRTovyIOoXICrBGxM4+/44g78bnGc4=;
        b=exUkYmaOAec/Ib/rBA4SXtKpKgpsiNR1tusFcQx1ohIgY1Kgc6KxYEyY0v1x75zTZV
         abNam+WiXUO8Vbcqscjg1E+oyC4IgQOQ/vAW5qAQzfUgdAfU8FaqW/imyc8dkGNED68Z
         +G886K5MwvNsHT/tFxQjgtK8IEhuK8AORVh2HgS0WuD1/EEMrLuudHm+r4EpfFenYU/o
         7UrZzgXofF8glIowS6Si3Oon/+oHLnEJlJUk5llWdSjPqyrebCyeUe5QkWbHZOpf4yyw
         40CJnHRO9FEvrZelMSYucISVjYVuozPCdEVlVikM+bZXnHyOLM72eHCA2uCNr903Tqv9
         lECA==
X-Forwarded-Encrypted: i=1; AFNElJ+jCEZdICT/qSbKj84oeXda1Y1yBZQie671n/uP/GTPcK0FbwnE8j0WOKflX5wmANGF8v4ksAeMQvw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6C8koto+hEZJTnZn02aPJv7I0u/KfMJEyBoKRTTaFIT+R9Se7
	x6GY9uOYDjMfsttxF37SGThbD9xTNjQ80uyWSgI53xLeaG5mYSj3Jia7
X-Gm-Gg: Acq92OHjZe0VDAXlkdfMUmafrHixmilBic4+T5QxiXdfxzilxpxWLK42G9b2Dy9cTX+
	7vXyckBaIuOPn9BpbuJxastqipXDOS3btmza8PN7DF+HjHZCBnyO5DmfXvHPT51t3acWhzK9OYV
	HxS2Z+C4Jz/sezB5LT2bTbqLuil3kGeX6V+R7J1MGeKsbbVVVc+IK/D5yNLUs3Fj//WV+s8PlNR
	UhKO0XcL5o352zeJVCRtcf7mFSYcDSHS0aZt5WLUqroxrJYX0Nmt0XwMssroEVg2Q8jO5VC7kui
	OU9vgzGZGRRcCu1ub+b9VEn61UIPFSRzUPJefcXs8p1uUtWuaUwWotDxQLh5NTvtuahoQUJBo0L
	vIqTC7X6dlsxrURi7HbQRiDXmtYAIwhDL8eSeNzKxiD7IIO29qo4zYMesbT9o+pWRcqpNdX0pPz
	RTV08rV6eBkjOMEhKSZZnejl9HZFg=
X-Received: by 2002:a05:6a00:a227:b0:82c:9c90:6ea0 with SMTP id d2e1a72fcca58-83f33ad8782mr12373366b3a.3.1779115440605;
        Mon, 18 May 2026 07:44:00 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm13165150b3a.33.2026.05.18.07.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 07:44:00 -0700 (PDT)
Message-ID: <aa4f29f5-b683-4d07-bc5f-fa5520ba2302@gmail.com>
Date: Mon, 18 May 2026 22:43:56 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] fstests: verify fanotify isolation on cloned
 filesystems
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
 =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
References: <cover.1777357320.git.asj@kernel.org>
 <5857d9f33de7f0ea8ddd12c36334c6463c0bfe0f.1777357321.git.asj@kernel.org>
 <agK83s6NBxpbDREJ@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <agK83s6NBxpbDREJ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/26 13:38, Christoph Hellwig wrote:
> On Tue, Apr 28, 2026 at 02:42:54PM +0800, Anand Jain wrote:
>> Verify that fanotify events are correctly routed to the appropriate
>> watcher when cloned filesystems are mounted.
>> Helps verify kernel's event notification distinguishes between devices
>> sharing the same FSID/UUID.
> 
> Do these tests pass with all major file systems?  Or does this reproduce
> the previous btrfs issues in this area?


Yes. The major FSs (BTRFS, EXT4, XFS, and F2FS) all pass, except
EXT4 does not run `generic/801` because statfs `f_fsid` is not
unique when the cloned FS is mounted. Also, BTRFS requires the
kernel patch mentioned in test cases `generic/802` and `generic/804`.

`generic/801` fails in an SELinux environment; this can be
fixed with the following changes in `generic/801` I'll add
this change in v5.

-------
diff --git a/tests/generic/801 b/tests/generic/801
index e1282f4e3d71..384e82120d4e 100644
--- a/tests/generic/801
+++ b/tests/generic/801
@@ -23,6 +23,10 @@ _cleanup()
        umount $mnt1 $mnt2 2>/dev/null
        _loop_image_destroy "${devs[@]}" 2> /dev/null
        rm -r -f $tmp.*
+
+       if [ -n "$old_selinux_state" ]; then
+               setenforce "$old_selinux_state"
+       fi
 }

 monitor_fanotify()
@@ -49,6 +53,14 @@ mnt2=$TEST_DIR/$seq/mnt2
 mkdir -p $mnt1
 mkdir -p $mnt2

+# Setting SELINUX_MOUNT_OPTIONS to null still fails fanotify with
+# permission failure, so set SELinux to permissive if it is enforcing.
+if command -v getenforce &>/dev/null && [ "$(getenforce)" = "Enforcing"
]; then
+       old_selinux_state="Enforcing"
+       setenforce Permissive
+else
+       old_selinux_state=""
+fi
 _mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]}
$mnt1 || \
                                                _fail "Failed to mount dev1"
 _mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]}
$mnt2 || \
(END)
-------

