Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3B718E359;
	Mon,  4 Nov 2024 06:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730703150; cv=none; b=AFZjduqU4NRvootnU+2272B1b1wqEk9VL2103YXBwFno/SEs2Q1G6M8lynGNks3Chx8dxs5SnOTowWoWNi0X6U0vLOai0Y0l4N3WoakDk3kzmMTOUmezuudNFrE12Y4OM9rPvtxpB4zi/ituNc+fxdI6NdAX0dT/yeofE62TWBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730703150; c=relaxed/simple;
	bh=N9tbKly5zWUOAzeiQ1Wxfd8kcw035wi4bUXqYm/ne4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pwSSV/2/R7skVnEbhVvK4xzK7+pqTsefmsnP4Y5YtvMV7nhxs9KLxuP3tyPPPN+izNI+0JrpmKH6E98QQ6TGQRGUZ+RXvVreqhqTDBZrQcF4PQqCGwUOdvO3vzBSy0n5Zz67C7KNPZO+p7s829IGHAGwGNJGbFmg3PZqmk+Qg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7GdqO0o; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7GdqO0o"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7ee6edc47abso1134454a12.3;
        Sun, 03 Nov 2024 22:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730703148; x=1731307948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLCR8Gw/jIPv8Z4kr33wovyxqJ+uVehxMy/GMieinYU=;
        b=e7GdqO0oTlXQ4OpcIpaI6Yfi3X6V1MS1rng+yI/1AtuH3S625bqknZUGnqidcpKFRg
         qHJoJ9cH1PtnbF0qBCQROcybpJzDZuDTtuXK9mFu7YUlz0RPOws40yhnHLMnjzBU35YZ
         tEfJx2+PnhqIX9Z2TMM5mNlYgl+ERoSfi0Lj7RFJggjCEWjWsO2CmMdnf7zZDgTnvY/7
         hdnJf9SZoYj08lUSrd/TIL+Z9doko8IdJBDhxk6GzjX5bufqEDKVFehwlqOUasRZZQ+f
         EXa5U8yO7OBlxobBjbHvW9xVqRzDw9bboxVNOy3Y8YBkgojGvYKZ/WVmQzCgV478B92D
         A/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730703148; x=1731307948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uLCR8Gw/jIPv8Z4kr33wovyxqJ+uVehxMy/GMieinYU=;
        b=viKWcyL6GcxiNadkmz8edOPCoaBwuRjCcBxKMkW3RCxZKf63VbKDGNFXHi8/SEdn4N
         krZ0BoYkOHfC0s9qAy2S7TCT0ZwTAaPHoSe61jWowENoHK+oW94vspFygd8CppQrMk6V
         WnVsh5OhirpNN/ombkGs+ZXctvU4vjOGEvvfAeilJOukS0zVkMd4Pxta9FIT41Wj9zrI
         MU9AMopz004oYrQRrQqPq2iAHXeNf9f56EK6asyi5TcgPq7PssPLR15vWexNwy2T1ePo
         P0TirLPwHuSAYb7DcRVetD8ERMnx2wUZne2dYWyN9+vz3X7IoYRFwzbhu5f8VqtM245j
         3pgw==
X-Forwarded-Encrypted: i=1; AJvYcCUeipMvRhp5YfwkmA/qVvPgw+8XpXLJjvSXj+GhmL+GwZEZRq9TdZXsxeZPS+vYLtbcVYCWDOvnINEs@vger.kernel.org, AJvYcCXpvwWlt19yHfH/OyCRVPWfoxf5V4K/o5w+Sspx0AOKOzMknmTUuZUSGrIMYNAzoghv0voSTvwJFlfje4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT6YnyPUAoQWxLc+2uZIU/l/Gs1Ns4bOUJwGLS2GOVZ3EU9/Jm
	JfcbLimffSvJOkX8pWBSK7+cVPGGKp2SaaNPYCzTbsZjPdcmftB8
X-Google-Smtp-Source: AGHT+IH7bgUABKv5BkXAi3QrGJrF4AoC/JL30KM0cLhoBHUX1jva3S39frSHGcTv7FKMFhz0u+/Jew==
X-Received: by 2002:a05:6a20:431f:b0:1db:e1b0:b673 with SMTP id adf61e73a8af0-1dbe1b0b8f8mr1905936637.9.1730703148274;
        Sun, 03 Nov 2024 22:52:28 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93db183d8sm6749278a91.37.2024.11.03.22.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 22:52:27 -0800 (PST)
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
Subject: frag.sh 
Date: Mon,  4 Nov 2024 14:52:14 +0800
Message-Id: <20241104065214.3831364-1-zhangshida@kylinos.cn>
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

#usage: ./frag.sh $dev $dir $size_k $filename 
#!/bin/bash

cleanup() {
	echo "Ctrl+C detected. Killing child processes..." >&2
	pkill -P $$ # Kill all child processes
	echo "exit...umount ${test_dev}" >&2
	umount ${test_dev}
	exit 1
}
trap cleanup SIGINT SIGTERM

test_dev=$1
if [ -z $test_dev ]; then
	echo "test_dev cant be null"
	echo "usage: ./create_file.sh [test_dev] [test_dir] [file_size_k]"
	exit 1
fi
test_mnt=$2
if [ -z $test_mnt ]; then
	echo "test_mnt cant be null"
	echo "usage: ./create_file.sh [test_dev] [test_dir] [file_size_k]"
	exit 1
fi
file_size_k=$3
if [ -z ${file_size_k} ]; then
	echo "file_size_k cant be null"
	echo "usage: ./create_file.sh [test_dev] [test_dir] [file_size_k]"
	exit 1
fi
echo "test_dev:${test_dev} test_mnt:${test_mnt} fize_size:${file_size_k}KB"

#mkfs.xfs -f ${test_dev}

if [ $5 -eq 0 ]; then
	echo "mount ${test_dev} ${test_mnt}"
	mount $test_dev $test_mnt
else
	echo "mount -o af1=1 ${test_dev} ${test_mnt}"
	mount -o af1=1 $test_dev $test_mnt
fi



# Parameters

FILE=${test_mnt}/"$4"   # File name
echo "$FILE"
if [ -z ${FILE} ]; then
	FILE=${test_mnt}/"fragmented_file"   # File name
fi
TOTAL_SIZE=${file_size_k}	# Total size in KB
CHUNK_SIZE=4             # Size of each punch operation in KB


# Create a big file with allocated space
xfs_io -f -c "falloc 0 $((TOTAL_SIZE))k" $FILE

# Calculate total number of punches needed
NUM_PUNCHES=$(( TOTAL_SIZE / (CHUNK_SIZE * 2) ))

last_percentage=-1
# Punch holes alternately to create fragmentation
for ((i=0; i<NUM_PUNCHES; i++)); do
    OFFSET=$(( i * CHUNK_SIZE * 2 * 1024 ))
    xfs_io -c "fpunch $OFFSET ${CHUNK_SIZE}k" $FILE
    
    # Calculate current percentage and print if changed
    PERCENTAGE=$(( (i + 1) * 100 / NUM_PUNCHES ))
    if [ "$PERCENTAGE" -ne "$last_percentage" ]; then
        #echo "Processing...${PERCENTAGE}%"
        last_percentage=$PERCENTAGE
    fi
done

# Verify the extent list (to see fragmentation)
# echo "Extent list for the file:"
# xfs_bmap -v $FILE
df -Th ${test_mnt}

echo "umount ${test_dev}"
umount $test_dev

xfs_db -c 'freesp' $test_dev
