Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B13359FA4;
	Thu, 20 Nov 2025 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763654961; cv=none; b=mxg2ofmg+XZ0vVWTmdO/UzgApibwg+GPcowANfxyFZIftQtvKlX6SiM8l33D0LkFN5AbWhYmQDbU0AA1MNjVTKL9Qy/CEfXe72ySm3MHnV9TQxFVpKpBjk+XUpxrHYxV259SqKlDeBH3i34srOoZXNBqU6dpmgIoM8VyOZaalFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763654961; c=relaxed/simple;
	bh=AwqLMpBQ9RurXz/vus8yAV1vgf5VKv7adpyy0/f7EmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnhdf9/8Qq7izKwS84FDm/tvdKLbm0BRIps5bkByttoWK3Mir0HOR0JoJSU5YWJaWkLzlvexfoDMB1Lvl+JQMwgpA7x2GxYo/6e5TZexhKKat4DnlF5Un3qTQbVaqVOB6WohjotHPjumq8mz+ZoT2njtDFeHBTBn6fG6JHa7Jc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqiXcqnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqiXcqnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71B9C116C6;
	Thu, 20 Nov 2025 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763654961;
	bh=AwqLMpBQ9RurXz/vus8yAV1vgf5VKv7adpyy0/f7EmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqiXcqnCflGE5L0J+jx2uQFcB6JQ/7nRwhKce6XL3IsDI3sxwkryCKu4MFAHsQuz7
	 oqm91uFLPoOet7j1G7wgBCGUtwVlMc5RkVD49A5HzK5wheEwRVA531Kh8SHqoL2ilX
	 UsR3Pvk8DvWw3P1O/nIMYajbpa5DAExPegDBG7aZH0YaJXninYUFInyZD/r8J14c8R
	 F7D+i7ih0rq38AemaWWIXT5+Y7juON70HmLFEBFGCSXV93dgB2gOz6D0LMt3bCPR8c
	 5PpewbVuuPrwp8IOy82Rjpa+d97YBp3Cu9oX/knbACUHqrSydyuCzjVUmVq2T02RmD
	 x23KbNfB4ayyw==
From: cem@kernel.org
To: zlang@kernel.org
Cc: hch@lst.de,
	hans.holmberg@wdc.com,
	johannes.thumshirn@wdc.com,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] common/zoned: enable passing a custom capacity
Date: Thu, 20 Nov 2025 17:08:29 +0100
Message-ID: <20251120160901.63810-2-cem@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120160901.63810-1-cem@kernel.org>
References: <20251120160901.63810-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Extend _create_zloop() to accept a custom zone capacity.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 common/zoned | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/common/zoned b/common/zoned
index 88b81de5db4d..51c011b247d2 100644
--- a/common/zoned
+++ b/common/zoned
@@ -61,7 +61,7 @@ _find_next_zloop()
 }
 
 # Create a zloop device
-# usage: _create_zloop <base_dir> <zone_size> <nr_conv_zones>
+# usage: _create_zloop <base_dir> <zone_size> <nr_conv_zones> <zone_capacity>
 _create_zloop()
 {
     local id="$(_find_next_zloop)"
@@ -80,9 +80,13 @@ _create_zloop()
         local conv_zones=",conv_zones=$3"
     fi
 
+    if [ -n "$4" ]; then
+	local zone_capacity=",zone_capacity_mb=$4"
+    fi
+
     mkdir -p "$zloop_base/$id"
 
-    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones"
+    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones$zone_capacity"
 
     echo "$zloop_args" > /dev/zloop-control || \
         _fail "cannot create zloop device"
-- 
2.51.1

