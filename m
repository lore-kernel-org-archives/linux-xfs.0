Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73DB38C421
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 22:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779921705; cv=none; b=PskZdClXTKJWlX6RANDsHY4llKCTZxAtRhfyrPXAFDU4bJ4ldrRM5ppaSxcAN/O5bDd/cUBEYhxnUt8wtsJTcKb8/qI4tXPKiSHdXwQvA1duH4NXfQ0lnDPY4oQVReO8hQHtUJpfKp4dbJ2PBAQunZWO4+yx0FbyqUFPkqQYBE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779921705; c=relaxed/simple;
	bh=LWyhWusqHr4rQgdvmPOrVaCWSEHYAt554Q0TgVqFBAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJXTQ/IMVWyJ92xEVPDmSGJU61t99YU16+BfiYOoJ+9plUyK2W2BBRSiO3BbZVAHjgbHwXWLDwGwNuXOAoIQO7KKV6OIi5pCoO9EP71yhZJP2BzRi0dPwdkaF47zlAfY8C31NIgspxBe4yfRHZJKG93SC7EcA/De76vTsOIBqLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DiP3Fx58; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DiP3Fx58"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8383fb7143aso5397716b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 15:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779921704; x=1780526504; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PS1QiPPseraqYZzSGuyGeQTFkHJ1l+wgxnVan1O+b0I=;
        b=DiP3Fx58Z5VrEdwY7kjptCOepOOHDy8zV0Ac5ySjdW4f+l1+vDiBNiKiBzu636TGcU
         3sd38WaRMSNrRZa7jxWC6anAxvVtqvkF45zWGzfHYfsB63mQpm0pE2dVt0ekNpNkLrGV
         n7b8kNYbZykxiWAz0q80vZwxp1S4oPKT0vqK2gRuKayCrK9iKcs/yLF1DhugXB/yVhzr
         i+cNR7W1V1EHZvWhyp1OGlh8hOpQCMkEieT5Csk7MMjEqzw1c3aSKtzhMAqzX6fx4r/O
         lGL6DMqEu1XxRvJ60EBWZ1DIt9Te+oi3ZPE6r1i02MYAksmoVDr/RVwd3vRlv1pIFcy+
         xIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779921704; x=1780526504;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PS1QiPPseraqYZzSGuyGeQTFkHJ1l+wgxnVan1O+b0I=;
        b=onwMOYU7ezFOkhaWIYgvwV37hY32cezKsIWWv2tRBj6QQ2YN3UMARG6dsImIHGMFT+
         y98ZzEh/1XHEAjES/EcUr+ZMEE9nW5VNQCZuEUudn8J3jLMZeB1rz5IE+fexDX2waTPq
         ptjFKSItS+d0xbRSa7426aU9kLaP9RnLTKnV/C2SI1+i+jRFslWwZLlknzRFSNsfkQFS
         TfVUHJTl4zH/X0IN9Ak0n2dOsuQzNEBuhaAWG3I6+gOGXlu7NIEnbnOPRCEu7PMPkYcu
         fMve8OgMTZEBHc5+Q9EDYfCyOe9jAtd16IAx2Lyk3Un9BsPX+ZKnqAJ2Y4tpAI393CAI
         s+hQ==
X-Forwarded-Encrypted: i=1; AFNElJ+P2CIGzO9Z48wkNfFRfpuQ3aXWNos8HumUXAkeCEDWq4sW8fbmoDSS6gDjsbBW/1MlwdQxp0Zvskc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW5bxCJnTMK54+5ppvR5yxm7HF/N8o/gqdzEwCKLxc0V/2wDE5
	4lDy6mrngWWlf0iextIK9czTmg2lf4bkCA0Gm33PpDEWSZksdyMRArGP
X-Gm-Gg: Acq92OHuaajZi9W3c5Zh6RQeu9q/0TZpnA/DzpSJyOTG0kI77EwOENNYGSJJMpLKxft
	yYVi3eVz0Je/pfQmaAgQp45zjPjtOGLuwQSzTLHL4ZNRHAaWQ9GivPff5Vn+ebb2UVqrAYj5kh5
	PllekUpUWCn3MHv14U0g8c+0sAJcllihKWWXwXcDVuvVFaPXItwP2XFfxP1unC8xALNC838Ypt3
	MpZf1zkdvJ/LJNrvh9uc7nLKkBtwB2UTdS7NpgPZdSXt4YMZA2cKA6TcU5z3Mjqe3U/OJdqVbBW
	1iIeVlj82tOBTWEAZAharqn+/EQlbC7Fu1SeCXah6zeBeTVN8aOkmQtLPU0gwVNnF7CS2dukdKL
	mBeYYm83TX9h47K+zeOoyETnR/cZchXngIX8XCppz+E2JDNxxo0ssy+hblkyo5Vgo4kteNtgk0a
	q8puz+voxjoUwaRMoFphNAQ4+Cl6/J5a9QM6+FRQ==
X-Received: by 2002:a05:6a00:3a14:b0:835:41f3:f453 with SMTP id d2e1a72fcca58-8415f3f67d5mr21283194b3a.17.1779921703896;
        Wed, 27 May 2026 15:41:43 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d6eac68esm3382981b3a.15.2026.05.27.15.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 15:41:43 -0700 (PDT)
Message-ID: <e039c677-073b-4201-8588-ad84d58639e4@gmail.com>
Date: Thu, 28 May 2026 06:41:39 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/10] fstests: verify f_fsid for cloned filesystems
To: Christoph Hellwig <hch@infradead.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, amir73il@gmail.com, zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <a24645463979d0550e0010030995b0ed609215c1.1779367627.git.asj@kernel.org>
 <ahP2hjv9zl_WL1kg@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahP2hjv9zl_WL1kg@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/5/26 15:13, Christoph Hellwig wrote:
> On Thu, May 21, 2026 at 08:54:55PM +0800, Anand Jain wrote:
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
>> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
>> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
> 
> Seems like these are stuck on the btrfs list.  Any progress on that?

They are in the `for-next` branch of the Btrfs Linux repository:
https://github.com/btrfs/linux.git
