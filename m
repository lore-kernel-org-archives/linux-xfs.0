Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FAF17C9;
	Sat, 24 Feb 2024 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737022; cv=none; b=WxTfwSQLZLvJAiSB/B/8KODv+35Mzv/ZeqRXCyf5vHa1sdLPZXSzsf8E5RY/fckwljlAUccWUsRLwUQ6u2a87yx6Hth7adG1V6cQNuyB+Mbi9Hd0A7XOqTxeuATNfxlUa0Fa56HHZNw6XSG18QUt7eJ+bryPHYSGKz8mmm/pl2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737022; c=relaxed/simple;
	bh=m/dGn8S+Tun6ctgDshvujNW5mlJCoNbY7DUPJFApM/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIBIqJHmC/3XTQgxn+pYo2jTRBoMvK7tdJMq0K2pPD6cE/fOFIXIYqYIezpVaoafxqZ5CJqdaRsiGUH+CtMyd1XhnDS7SBH2rrUQINc0VUdaMa4lixOUvM8giPF4sLQV1tGLMCrNUFFNbki2J+JpVcaHaDIh1uUn9b9cnjiKYqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ro9cjf/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ro9cjf/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58D7C433C7;
	Sat, 24 Feb 2024 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737021;
	bh=m/dGn8S+Tun6ctgDshvujNW5mlJCoNbY7DUPJFApM/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ro9cjf/q2cHCcquHPuUDHaQzSC5wXBIlSFxeXJ5jDUVGf1h9siSXu3Ni39ZDTnJXS
	 b+hkazhno9vxHCMeUC6+dZihxhYlIXxzTXKlu2vFCC4FL+f9K9Epkmo25/PJPlvXJ8
	 5cjYuuIxTim7c4bRFj0t4rk+2g9jEeQUGP/v+OFDn0NEK91CaYekA9aCqcButtGGQa
	 n3InHRJnNkaKgKPPAnS87LtZDYc0PDk+X7nuHipaJPTPxsZeeOQtLeUDUd8ytctw3X
	 mWO4xdzF0j2zQ4znwJnYvVF07/mdRIvHpJTd4rb1nLlI9J2cwPKIbosa97EPqJECls
	 CQMIFT2Y8sBww==
Date: Fri, 23 Feb 2024 17:10:21 -0800
Subject: [PATCH 01/10] time_stats: report lifetime of the stats object
From: "Darrick J. Wong" <djwong@kernel.org>
To: akpm@linux-foundation.org, daniel@gluo.nz, kent.overstreet@linux.dev,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <170873667957.1860949.223294173509859015.stgit@frogsfrogsfrogs>
In-Reply-To: <170873667916.1860949.11027844260383646446.stgit@frogsfrogsfrogs>
References: <170873667916.1860949.11027844260383646446.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Capture the initialization time of the time_stats object so that we can
report how long the counter has been observing data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/time_stats.h |    2 ++
 lib/time_stats.c           |   10 ++++++++++
 2 files changed, 12 insertions(+)


diff --git a/include/linux/time_stats.h b/include/linux/time_stats.h
index caefa7aba65a0..eb1957cb77c0d 100644
--- a/include/linux/time_stats.h
+++ b/include/linux/time_stats.h
@@ -78,6 +78,8 @@ struct time_stats {
 	u64		last_event_start;
 	struct quantiles quantiles;
 
+	u64		start_time;
+
 	struct mean_and_variance	  duration_stats;
 	struct mean_and_variance_weighted duration_stats_weighted;
 	struct mean_and_variance	  freq_stats;
diff --git a/lib/time_stats.c b/lib/time_stats.c
index 081aeba88b535..8df4b55fc6337 100644
--- a/lib/time_stats.c
+++ b/lib/time_stats.c
@@ -158,10 +158,16 @@ static void seq_buf_time_units_aligned(struct seq_buf *out, u64 ns)
 	seq_buf_printf(out, "%8llu %s", div64_u64(ns, u->nsecs), u->name);
 }
 
+static inline u64 time_stats_lifetime(const struct time_stats *stats)
+{
+	return local_clock() - stats->start_time;
+}
+
 void time_stats_to_seq_buf(struct seq_buf *out, struct time_stats *stats)
 {
 	s64 f_mean = 0, d_mean = 0;
 	u64 f_stddev = 0, d_stddev = 0;
+	u64 lifetime = time_stats_lifetime(stats);
 
 	if (stats->buffer) {
 		int cpu;
@@ -183,6 +189,9 @@ void time_stats_to_seq_buf(struct seq_buf *out, struct time_stats *stats)
 	}
 
 	seq_buf_printf(out, "count: %llu\n", stats->duration_stats.n);
+	seq_buf_printf(out, "lifetime: ");
+	seq_buf_time_units_aligned(out, lifetime);
+	seq_buf_printf(out, "\n");
 
 	seq_buf_printf(out, "                       since mount        recent\n");
 
@@ -263,6 +272,7 @@ void time_stats_init(struct time_stats *stats)
 	stats->freq_stats_weighted.weight = 8;
 	stats->min_duration = U64_MAX;
 	stats->min_freq = U64_MAX;
+	stats->start_time = local_clock();
 	spin_lock_init(&stats->lock);
 }
 EXPORT_SYMBOL_GPL(time_stats_init);

