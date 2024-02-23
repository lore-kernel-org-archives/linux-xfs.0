Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F2E7E579
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708694638; cv=none; b=QKSZX68MBnSjAcTfv1kIEt5OG1bdw128pJObDJalm2UAV1v5TwQOxnI/YKu/2JLduFe87ktdFywFvU2GdCcfvOvKJyQpYCTEjwpRJVgLpB69MXReXr7AhTmtmpuWENYii3XuSs+RWs7PQJ0+fAU/cjy7fXPWkkXWD+trClVRqyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708694638; c=relaxed/simple;
	bh=6e0O4DMzFkHvn7pXNTJf65SMbBZkdyOQG4/zKdeHt/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9Zs9vDDTlCWLmoqP/pFI+DgOWRTedcP65MjWU9ql+7Yz+aZtwM4vJomTsCzTcKp++3AsdnuO0a0+rWFjkXttJ/L7itIcHea/JVONm+zxKELp5MVsmIYraMco6zi2C9Pf6AjFuZL5OxbD0er2LLOUU9tcbighzSLL8yEkwgOWBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O/3AiaNV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/3AiaNV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708694636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hqt7S1NoHacsgWuh60F4sxJhipun6fhVaSw2FUE+AfQ=;
	b=O/3AiaNVnkzaUz7CPQW6rEVvqJ5Tmew8q5Vga8MI+sS23Qxf60sNkh5LJOS7kh3oVmvPmz
	SqBa49aZy3cvIajIOzPcmiFR6CLxbILg+z4Z1GtQRH0Oxtm6U2LSbGgrRKRTV8ngG6zY4h
	KzziJeqRWhbQU1nH9/zwfP2xdHYY6Ss=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-YhvwrxYRPhq7RLwxzHTtpA-1; Fri, 23 Feb 2024 08:23:54 -0500
X-MC-Unique: YhvwrxYRPhq7RLwxzHTtpA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d9f425eaaso130446f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 05:23:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708694633; x=1709299433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqt7S1NoHacsgWuh60F4sxJhipun6fhVaSw2FUE+AfQ=;
        b=tLF1oZfzVEdzP32AAj3MwAsjT+UUmDaAN8hahNxETIiluxPF8DrdT7UqDcTkjSKTdp
         atYKwZ+Z/SvlJxHuJkVs6a3Tthur9xBHkVHha7/cROIs36/o+5Kson5HEHPUMby9mgWP
         FTIz2bKj5SoOwIAfJGBKJ6Jlhsib1ZRb6NpDru/7CWuGo6RfkfHUxWsObGb987RHGRDw
         +N9j54Ho/1WESWEFH+x939fwgkm9WVjKqxWcutxygPKk0OoxdmaQ2G6+jdFqKUUu7hgR
         dKrm49eKhklftALqfxARyjuhQ2yRU+tDN7zvq4hK5PSThDtMFGvsWk49WUwUUISPrPjm
         9QqA==
X-Forwarded-Encrypted: i=1; AJvYcCXbY/mB+0Al99l3gKQVG5aBHj7sej50GWg4J8DH64ijPfss4Qz9aBVLudb56aGJvWU3b5vTlxjnhQJaPfO32nUNNsTzqi4Gxmhn
X-Gm-Message-State: AOJu0Yy9RbQz4/EukyBqG0+HwZ/S4XGlBmiEDfyh9R5lTiNz/vUoJEaU
	ULek2fk4D07hbiXEUxKvJTLauZi6uzzVoFPAEhG9PbgfG60RShJak/M7ka7KXojOuctHYKzI6Ns
	5SKFxLOHriEPv9Z15d4cIKSAvAXVZdjYwYjonNE0wlJ6nIvaXoIl6Zjt1
X-Received: by 2002:adf:eac3:0:b0:33d:7eb:1a6a with SMTP id o3-20020adfeac3000000b0033d07eb1a6amr1294412wrn.68.1708694633702;
        Fri, 23 Feb 2024 05:23:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFcPXl8fo1bQL43nBgcdbRjOKnZSJ455k+RrAoRssBnbauM8/hwRjxl2I7+BEiwDHQq9Z7L/Q==
X-Received: by 2002:adf:eac3:0:b0:33d:7eb:1a6a with SMTP id o3-20020adfeac3000000b0033d07eb1a6amr1294402wrn.68.1708694633392;
        Fri, 23 Feb 2024 05:23:53 -0800 (PST)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id l7-20020a5d4bc7000000b0033afc81fc00sm2737566wrt.41.2024.02.23.05.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 05:23:53 -0800 (PST)
Date: Fri, 23 Feb 2024 14:23:52 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com, djwong@kernel.org
Subject: Re: [PATCH v4 09/25] fsverity: add tracepoints
Message-ID: <copvwl7uhxj7iqlms2tv6shk4ky7lce54jqugg7uiuxgbv34am@3x6pelescjlb>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
 <20240212165821.1901300-10-aalbersh@redhat.com>
 <20240223053156.GE25631@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223053156.GE25631@sol.localdomain>

On 2024-02-22 21:31:56, Eric Biggers wrote:
> On Mon, Feb 12, 2024 at 05:58:06PM +0100, Andrey Albershteyn wrote:
> > fs-verity previously had debug printk but it was removed. This patch
> > adds trace points to the same places where printk were used (with a
> > few additional ones).
> 
> Are all of these actually useful?  There's a maintenance cost to adding all of
> these.
> 

Well, they were useful for me while testing/working on this
patchset. Especially combining -e xfs -e fsverity was quite good for
checking correctness and debugging with xfstests tests. They're
probably could be handy if something breaks.

Or you mean if each of them is useful? The ones which I added to
signature verification probably aren't as useful as other; my
intention adding them was to also cover these code paths.

-- 
- Andrey

