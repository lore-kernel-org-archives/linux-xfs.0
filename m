Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0414A4F7;
	Mon,  4 Nov 2024 06:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730703242; cv=none; b=qxK3FH334dMvkFv5J82oj2+1xEMCd+CSvOeo0kyJ/1WXWpfbi+vMgPne+eH5r1XPicAuXAgqU05XiEg/N7Cq9UwLJJgjU5P7wJklRr1wTklf7WJ9ngz2cveQHLrBDIeGT2+46w9rF2lfV4pfJIVY1kUzTpWaBfHByrE+QltbpfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730703242; c=relaxed/simple;
	bh=k1dWrQ7lSnp6p5/PE9vrh69HMTl5rdIQcx0PZhfwWXs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VysSCgLFf5/snt5qEW4PYxWsrkkCZQTOK9KclVyH+xzTTNeqLJgIejh2CQYTqu3HoYMKHLbzNFG3rA2Jh+bwqoL4Ja8x0qyHteplRbQxB7Az2i0weXh9g/0NYlDhlC6az7vMxaqZO9fPBbu0D77dpY399ThAEx5RPvFYFtm4kzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f68TBY3i; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f68TBY3i"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20c7edf2872so36940475ad.1;
        Sun, 03 Nov 2024 22:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730703241; x=1731308041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S8p5d7HXsqB7AzWE+CG+sBsn46kI/zZFjCp0yegZDdA=;
        b=f68TBY3ixROyHIUkh0hBI00XFmmBpHuKXP3wv9c/tcS66i2egYz4nGDqICga2ZEZ91
         VMc22VMTsRME7VEkGwmSPhylEz6bveIt+ga66hsaRq8QJCxWcBfavG4w3hq8WWFOPy3P
         SVvysrbPy67KuPc/bLZz7opBXvWRomD+KrD1/qKWd3EiAWFDC6rcu136bRQLsNKud1+b
         wGO0PAovCrerAAh2gXx+BIXECNxlWwLKDlnAJ6+36UoPgzosInWJC9Wp0weXrJ0UZ0qq
         wjGjgaEs/XOkf6EdBzGlW26GIzSWFlqh19mDFT3Dg1YmOlhnCiLhBO6Zdee3yEClHxwM
         jrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730703241; x=1731308041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8p5d7HXsqB7AzWE+CG+sBsn46kI/zZFjCp0yegZDdA=;
        b=Emr5sY6DeJLbn2VRWXU5ZLqh3O+8PRQ2Regk5xN+Ul4VK4ZNRBzu0g6QWLTPjPw8CB
         iLwJimRzr1HPMp1E1O3Pm+xrI1SuDoi1IdaaJlaPLr0IAeTHmhzfcksWHc0WGK7QhIZo
         zALUGvMzz6HYuzrhMkX4gMAbERoc0ecwj1vQkBcmAXnAv9swLZQ7ER1QPpuBk9VDGMmX
         G3viRi9qPJvJ/yIYcd+AMhlaGKSSNO99MtotMcn5soj3lOeBmWV0cN0Vw7r7JaWRnejw
         4VYpl6Txr0etcXYxggmnHzyriFHOlchFdsTAvAj/YzwHN0rpqiRYrosHBtWViOygJI3m
         pErA==
X-Forwarded-Encrypted: i=1; AJvYcCWArVxkDdQDqQjWpas8+s6wYZ+jHFmXzE74n2m7R7iFPSKj1JMKtVYavF1shb7qxyhZqWnTHAsG35cAB08=@vger.kernel.org, AJvYcCX69Sk3+5ExSGvngGcNDI1g63a/80yohwY+Y70qcj24J1SrtssA9EqSXmTnIu7UuOQWjn+HU5Yif4tT@vger.kernel.org
X-Gm-Message-State: AOJu0YydZdG9MJa5xAeToneeA7q48yu8MRAXLpCNDBpI35OGrul0l8xK
	Ye2XHkAFCB14lvB05n8ZuWsXqdMQLte4PmlCmUr8CeM6xdGMmVNq
X-Google-Smtp-Source: AGHT+IGESmmww33Rtqiu3mA/7ixTLwlIbRBT8AFaHHQKxT/yDlmFRo/tjIwwiFIeRo1PMVoir78RuQ==
X-Received: by 2002:a17:903:1208:b0:20c:f6c5:7f6c with SMTP id d9443c01a7336-21119440041mr169848735ad.16.1730703240616;
        Sun, 03 Nov 2024 22:54:00 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee45296c97sm6270456a12.14.2024.11.03.22.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 22:54:00 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: starzhangzsd@gmail.com
Cc: dchinner@redhat.com,
	djwong@kernel.org,
	leo.lilong@huawei.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	osandov@fb.com,
	wozizhi@huawei.com,
	xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com,
	zhangshida@kylinos.cn
Subject: auto_frag.sh 
Date: Mon,  4 Nov 2024 14:53:46 +0800
Message-Id: <20241104065346.3831631-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104014046.3783425-1-zhangshida@kylinos.cn>
References: <20241104014046.3783425-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

#!/bin/bash

cleanup() {
	echo "Ctrl+C detected. Killing child processes..." >&2
	pkill -P $$ # Kill all child processes
	exit 1
}
trap cleanup SIGINT SIGTERM

./frag.sh test.img mnt/  $((500*1024)) frag	$1
./frag.sh test.img mnt/  $((200*1024)) frag2	$1
./frag.sh test.img mnt/  $((100*1024)) frag3	$1
./frag.sh test.img mnt/  $((100*1024)) frag4	$1
./frag.sh test.img mnt/  $((100*1024)) frag5	$1
./frag.sh test.img mnt/  $((100*1024)) frag6	$1
./frag.sh test.img mnt/  $((100*1024)) frag7	$1
./frag.sh test.img mnt/  $((100*1024)) frag8	$1
./frag.sh test.img mnt/  $((100*1024)) frag9	$1
 
