Received: from mail-vs2-f36.google.com (mail-vs2-f36.google.com [74.125.227.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586BC214813
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790957686; cv=none; b=IsgaC8K5iSbfDkUkQOdXxNuELtwiIrKRIloJlQFXMhm+4bauHvOm6PaIxBFqlmCYoTp09o88FGwyrwjwifFupwwdc9uQ4R5iS/zObPrQn3QV7Wn94QS2HvTXfz3J5W3YhuzIuCV3+lizkWJ/cfK19qzhCeZrIneZLZCUPxz4q5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790957686; c=relaxed/simple;
	bh=2iNwW7A1TRSmxqKHoPSlFRvPQH6TdJ3MOHK68Q9VWiE=;
	h=Message-ID:Date:From:To:Subject; b=Kh5tImlsxQEJWGyAG076uIjG3qm85UGLv0kDaLlhrGFwO6v67qR+HHrDF6qjs82IAYZ1t7G6TBtCIblQQpSKJ4C7TC69bivXVYIfLp3Iod4tL1a9+1Qa/9gW0xbhj82W/HmwQjA6HvowgfZQ6sio4BJ+a96VF4UlzYUcWG8tafc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BKP5QNUb; arc=none smtp.client-ip=74.125.227.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKP5QNUb"
Received: by mail-vs2-f36.google.com with SMTP id 71dfb90a1353d-5d47358f856so1455186e0c.3
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2026 09:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790957684; x=1791562484; darn=vger.kernel.org;
        h=subject:to:from:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2iNwW7A1TRSmxqKHoPSlFRvPQH6TdJ3MOHK68Q9VWiE=;
        b=BKP5QNUbQ7XpFXoiadvV/R0Up52UU99jF38BaJk4+OkunP1CEgz2Em6nh93Fcex+Ih
         1KFeAvEANyxbQobWPO7vMkj8MkTSOTwzRdyDUWppXyKRA7qpxrqIruf5Ee040ohVjB5J
         Mu9xK1pTFFCVXXkfwn+i/XrEa2ve8SFIrtLLYgSlscf7kKOxe33T9LkqxbDMdUZmOB9O
         7PC2EcIQxcdxppT4ivb6CpISKe9JGvDzkVv9ry1tELrEJ5tQxrmV5FsK7QbWMMLaUJrD
         QhgSGJkZwmuc5a6VrY/+fjltG2FJnhzu7qirOkYKFpNkQbeOPZmr5hH/VAnZ9BjAUAgA
         Ck/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790957684; x=1791562484;
        h=subject:to:from:date:message-id:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2iNwW7A1TRSmxqKHoPSlFRvPQH6TdJ3MOHK68Q9VWiE=;
        b=nHhGSyjFjSATCcGVSLE2Ztdb+vB0jF/0ZTqEaq3lSXigWEUJVBf0ezdFS6Q29WupXu
         VyamOTGeKkq6kzvUiJN3gsgrwmpB1Jr6nSALUJQxeopEO+WXGWFbQ8DdYiXC+s0ACej8
         Z4xAG2QU3x2S6RwxJorK1UW69Np4bFC369diSsk5nl8S/B9SwKzaawwGwnkl7JESOE7J
         5cMpgWscHiMZgEaqebPuU6efExmpVAPVW2/33nFBovLZfPMg9BRO1bwJo8L8HFVNOvWm
         LfzIzRRxuqki9MECJ4V232t03+Ba/q44o8Ja09X9uwheZIRJYhdlNSEiHSxhXFOr4Vml
         3SAw==
X-Gm-Message-State: AFq9FYJ0klJWzTxeOO9WrkEqpaOloPlLfMviEouobzcKTFs5sKOY7pz0
	vXRpWcm3uCd7YuvBJRNn24ir+nM7FJ2dv2fZCA3IxuK/qRZu2U+kxR3avGbFJ+gZ
X-Gm-Gg: AYBFou0/as7mIz/y+rp9hRf0cYNEIbA6gzBp11RlaW8d8isepwbXaB4wBh+w2bv3+X1
	QzGz9MyGvVwC3cvlWp4A8zTPj81p6w7asPy6c5vu/HA8Z+nHam7jKnTLnSxvYlij7x4ijILphJ5
	yeb4ERE7blzhzoWaLhCZ/K13RFlmiMDp8D1dJFG5r4196r4EXhsEK9PwaHATCEbYIHHRtorrPAl
	rkJNjYfu5KlkAu5EV8Wh2teqNIH9dPINdVZBvB4JH9p3mgoUtHhYYwQXV/rmOLvNLbpT8HV8jn/
	MSS4Dwels7hlW93kkijBlNks7VtRkAyNY1dSlNW1iai6Vae0P7/z4Pf715Hx8DWY9OXZVftH9il
	Gs3LA2U0j5wLLpO27H5b+my8GIWvzKHlb7Lc6nTR9or1GpECksoYEOMlH5yNEvEzvR4sx5DS+vc
	meZZxTHYF66S5L1aNmOOWj3sTucUwAi+xjqbMet7gJwf3gKuNf3UvSQ9hT5J5aSmR2Zy4ugc3bd
	4YJnUZxD4OIl+9/zFD3sZYxK4AV
X-Received: by 2002:a05:6122:6b16:b0:5db:4749:1730 with SMTP id 71dfb90a1353d-5db4749192bmr745638e0c.14.1790957683792;
        Fri, 02 Oct 2026 09:14:43 -0700 (PDT)
Received: from localhost ([43.157.185.127])
        by smtp.gmail.com with UTF8SMTPSA id 71dfb90a1353d-5da5ce773ecsm3987595e0c.1.2026.10.02.09.14.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 09:14:43 -0700 (PDT)
Message-ID: <6abfd873.8cf8f4e5.289548.0ac7@mx.google.com>
Date: Fri, 02 Oct 2026 09:14:43 -0700 (PDT)
From: susantamahanta604@gmail.com
X-Google-Original-From: PayPal
To: linux-xfs@vger.kernel.org
Subject: Invoice Generated | $449.71 | Ref: I-S8L8ZS5VSCTYFV
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Payment Confirmation – Order #94G16118US3020651H

Dear Customer,

Your payment of $449.71 has been successfully processed. Below are your transaction details:

Transaction Summary:
Order ID: 94G16118US3020651H

Product/Service: PC & Family Security

Payment Method: Direct Debit

Amount Charged: 449.71

The transaction will appear in your account statement within 24 hours.

Need Help?
If you did not authorize this payment, wish to cancel, or have any questions, please contact our support team immediately:
📞 (859)-340-6239

Important Notes:
This is an auto-renewal subscription with PayPal.

To cancel future renewals or request a refund, contact Billing Support at (859)-340-6239.

PayPal will never ask for sensitive information via email.

Thank you for choosing us.

Best regards,
PayPal
4011 S Utah Ave Davenport Ia 52804 United States
