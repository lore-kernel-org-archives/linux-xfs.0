Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD93A3C454E;
	Mon, 10 Aug 2026 11:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362939; cv=none; b=V5ALLEBDEkVp4v5FFhjMjSBqokbYa8N0/+zuCKDsMTqyJO67JzRYxmedZ5uOiWoHXlsuR4UI6CqK16sXZtIqImtcAyK2HhKUxFtt1hNSzw/Cc6807p5D6Xq08WEHh/mH9FwSXT03swoiIo12suUpk2VYTYVu8wR4xdP/Q8Cn9yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362939; c=relaxed/simple;
	bh=Joc9we0AmeGQByM4oyJPe9T/WsJpJI/QZGokE/g9QGk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AmUVzxWv/sGCKfVF6UiPPCRXy1d7dQm+BWaXLdywyINEOuAejXbPGhV+ix7iiCMR+ZVKstZG8kMf+97N6xGzM00Isy+pWlXaZrgnO+iNR+wwTlEKK0q8gyKm9iqKYYX/iKaSyhe/cBfJZJfvVbZFxdNYHrDIaRqSuj2KI5Mfypo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWwL600h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWwL600h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172731F000E9;
	Mon, 10 Aug 2026 11:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786362938;
	bh=05A2TTupaj7ujKdllSdPhqDVz5iKJV8mZAcWO77ccZQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EWwL600hBAdLm4/wvLdI8S3na+AWIe/+d7k8NQ0pWTo2bY/ic2dsourpgu766vGut
	 XYPI15cK48/+zUGmIbEpPOzoU3wJnszySdoSFUBYceiPWX9MZbawX7aBA0hn5gMmGQ
	 n6iqwJ7e4ITRMmdIiQ9lDl4RTM8KtM8XaWQ4jMCh4kLj3QC6MqPICtuzYwAphgIOMZ
	 ERBlzzmonzYV5ix1jL7hwWtOVuO4zunBnfdmLUZ92NQ5PJnwiuxZNpLfv1hDWNFl3W
	 DCAdyDaLBTzLHzvRoLgKRaohHHbt0bGAIAAoYx1IFlxm/QSv3r/euMx6+L46d4j8+N
	 U7s4TFiXarBwA==
From: Carlos Maiolino <cem@kernel.org>
To: hch@infradead.org, dchinner@redhat.com, 
 Hongling Zeng <zenghongling@kylinos.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 zhongling0719@126.com
In-Reply-To: <20260730084236.173288-1-zenghongling@kylinos.cn>
References: <20260730084236.173288-1-zenghongling@kylinos.cn>
Subject: Re: [PATCH v3] xfs: use file target for post-log fsync fallback
 flush
Message-Id: <178636293674.58486.4052821152223615651.b4-ty@kernel.org>
Date: Mon, 10 Aug 2026 13:55:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 30 Jul 2026 16:42:36 +0800, Hongling Zeng wrote:
> xfs_file_fsync() has a fallback flush for the case where the log force
> was a no-op, for example fdatasync/O_DSYNC writes that do not require
> metadata updates. The current fallback path is expressed in terms of the
> main data device and explicitly excludes realtime inodes.
> 
> Realtime files with a separate realtime device are flushed before the log
> force, because their data must reach stable storage before the log commit.
> For the internal realtime device used by the zoned allocator, writes are
> out-of-place and update inode and bmap metadata from I/O completion, so
> the overwrite-without-metadata-update case does not apply in the same way.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: use file target for post-log fsync fallback flush
      commit: a94e648f03cf4e0def8ab3c74a1f9fe140720dd4

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

