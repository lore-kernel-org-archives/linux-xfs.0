Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9893E13EFE3
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734972168; cv=none; b=dCTlFgo1DKZtNeNsX9Ll4h7JbIUbnuABckB6EbkAapkbtFyuT/Hm2zIYuOmFFYFsHrHGft+FTYmeQOeQEtav8S0p4bYraDSILTipxeyeMtU8N/swNn2SHlJqFRA2L1sG5ZKFuGAxD7x8B3PDFjO6Y0Cf99cqsYlIrG/J7DlPxHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734972168; c=relaxed/simple;
	bh=nE+rRFjx4hQvRNe+6VinfhMUqUEGXIfu2QVZCGh0u1U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=NyUzdK47x6Y32tkSPsmqNOSOQ72jhtM80ecZqwaLuP11Bp1eTksLeq85JtJh18YJHmMe8MO74DWZhWbYVuQ8GC+dWkQTlhaE3VFVQlEipNnuaUN0s2QmjiicrLqp6o0rM2i/cBxdmACEOzRr/2i7JCtiLvWPYqJAVT/uNtW9kAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9FgxhzE; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9FgxhzE"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-30219437e63so56239871fa.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 08:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734972164; x=1735576964; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aW1+oigBn+y2c7OM1HRop9TN3gvoHdvPE7+0A/rrkDQ=;
        b=Z9FgxhzEuoslEqoKYPjUTHpjuZn9MXPVDaLf2lgsdoEy+NHXj0ArG0rYzHEiPyeqDc
         l/t2xHLpo/kSdQqyB4CXWbjtdJSqm67mgxvJCVPOFCD63TjE3pvcswrJD5Mo6EPhAToC
         yLuAcEyxD8PeF6VADfTFnGIKjKv+Hh1t6MjAPYIujpqNoTVyHRgCl+Tef6pggokScYPp
         qQA6yManh7M2Ww2OpfD7y7eAJRRdkNDdrCIf10VbKdP3bJKR3JH4kLNjsWOfe0OGZFkf
         ZD1nv3hJtoWVf8FyZsMawxvXF7a3YEgjwb07vZ9ZWbChkmrW6QuoAVbx4GjvDxXYSuG3
         +M/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734972164; x=1735576964;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aW1+oigBn+y2c7OM1HRop9TN3gvoHdvPE7+0A/rrkDQ=;
        b=BR3PUyJgRWysoES+S5GHaojxg4EOkDHaGx3FleQEgEWTD0HXaFqsqe2amn/bDn10HM
         2XV8YjWskGa/y2mV/Y+zQQTIgWKmDiybuq+ZW6dHDdWShJV5y40sOC0JrjupzcbfeOGr
         PB46MqYftigd6N5RjCsMs72oO4xwhLuFnWjF/OrStcQWmMTGfoa7JYYdqoB/NcpS30GH
         roeBPstRV5iVvpL7qS0IbvYyIljdmjxR8VWpLvNY1y0t6MPGFgereelHoguPDlCPp2/Y
         RuxN5IH49HRkc7vy4/Wu0hc1cuRkP0XNFG5hEz9uPK7aOiWLyNchp2Qzg9eFNYHIF578
         n49w==
X-Gm-Message-State: AOJu0YzrMI7gnQkznNhzooCHApxSWSRobpjCJYmcWOq1N/0MsBBglJFd
	g7XqVyiz4aFkgHldKXILzUWsLWwqjx1S+dIrdq8bjK7gaiscID9H+Sh147DFzj+sfq7dtwjB2rP
	dv4jUusAOOdANCXBvupCcqQZI50117f8m
X-Gm-Gg: ASbGncve0vKCyGTn3JojknZuj7rwXZKfdc4oWkIpQYvUmZygYjQpzQnXDzUNl5O52OD
	ot79xly25EvclkMzyLyCqNUQDUCnSaBE+JqIvaBo=
X-Google-Smtp-Source: AGHT+IHDfBMizMQCFXY3URZZfNNAqvtwfhyAAy8lTxto6eTnuCzwBOeqfCCfjonxB4C7jvt6jSG+6J8Vr6rpQl5QZnM=
X-Received: by 2002:a05:6512:3f04:b0:542:28af:816 with SMTP id
 2adb3069b0e04-5422946ed34mr4517478e87.20.1734972164252; Mon, 23 Dec 2024
 08:42:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sai Chaitanya Mitta <mittachaitu@gmail.com>
Date: Mon, 23 Dec 2024 22:12:32 +0530
Message-ID: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
Subject: Approach to quickly zeroing large XFS file (or) tool to mark XFS file
 extents as written
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Team,
           Is there any method/tool available to explicitly mark XFS
file extents as written? One approach I
am aware is explicitly zeroing the entire file (this file may be even
in hundreds of GB in size) through
synchronous/asynchronous(aio/io_uring) mechanism but it is time taking
process for large files,
is there any optimization/approach we can do to explicitly zeroing
file/mark extents as written?


Synchronous Approach:
                    while offset < size {
                        let bytes_written = img_file
                            .write_at(&buf, offset)
                            .map_err(|e| {
                                error!("Failed to zero out file: {}
error: {:?}", vol_name, e);
                            })?;
                        if offset == size {
                            break;
                        }
                        offset = offset + bytes_written as u64;
                    }
                    img_file.sync_all();

Asynchronous approach:
                   Currently used fio with libaio as ioengine but
results are almost same.

-- 
Thanks& Regards,
M.Sai Chaithanya.
