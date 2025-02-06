Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7480B12B94;
	Thu,  6 Feb 2025 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738833423; cv=none; b=bTrkyUSMA3MlufX1gnQLp6DXEEbFqVKHfjmBzu41pm9uKxgRJ/G2ZhCGxD4EQWDBsL6wkdW2rjC4TRcmsYAmoXv8tQGO2NLrDG1TVzfCyrNeptExvRiQbdFT8eP1AhLMWHk2F8LWGFPBB5pgXxU65lexXtmUCdV7G3Jcycalv1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738833423; c=relaxed/simple;
	bh=J4Jw6hCfAnfFcT8LYUjoO+YszJi+kEUP6N7RQM56PQ0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J8+9ZIokNpglmlYxla245GvUH4As7F+S6GvFwyy+3f0XJTjw3KoBEoXIu8tNHzkmeXGEFHGXNC02QphYAPql5aFprl6dcH3ePCHP7d2z6g+94XWpdITGPyehW5YO4hfH4EQPqhUe/f7CRX8xlNIcn40bI/ocAqgR1xls+ZwCp3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from unicom146.biz-email.net
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id EDW00134;
        Thu, 06 Feb 2025 17:15:34 +0800
Received: from localhost.localdomain (10.94.12.153) by
 jtjnmail201609.home.langchao.com (10.100.2.9) with Microsoft SMTP Server id
 15.1.2507.39; Thu, 6 Feb 2025 17:15:33 +0800
From: Charles Han <hanchunchao@inspur.com>
To: <mkl@pengutronix.de>, <manivannan.sadhasivam@linaro.org>,
	<thomas.kopp@microchip.com>, <mailhol.vincent@wanadoo.fr>, <robh@kernel.org>,
	<krzk+dt@kernel.org>, <conor+dt@kernel.org>, <cem@kernel.org>,
	<djwong@kernel.org>, <corbet@lwn.net>
CC: <linux-can@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, Charles Han <hanchunchao@inspur.com>
Subject: [PATCH] Documentation: Remove repeated word in docs
Date: Thu, 6 Feb 2025 17:15:29 +0800
Message-ID: <20250206091530.4826-1-hanchunchao@inspur.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
tUid: 2025206171534bc23d4d50169965adca0608dc6528377
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

Remove the repeated word "to" docs.

Signed-off-by: Charles Han <hanchunchao@inspur.com>
---
 .../devicetree/bindings/net/can/microchip,mcp251xfd.yaml        | 2 +-
 Documentation/filesystems/xfs/xfs-online-fsck-design.rst        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml b/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
index 2a98b26630cb..c155c9c6db39 100644
--- a/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp251xfd.yaml
@@ -40,7 +40,7 @@ properties:
 
   microchip,rx-int-gpios:
     description:
-      GPIO phandle of GPIO connected to to INT1 pin of the MCP251XFD, which
+      GPIO phandle of GPIO connected to INT1 pin of the MCP251XFD, which
       signals a pending RX interrupt.
     maxItems: 1
 
diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 12aa63840830..994f9e5638ee 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4521,7 +4521,7 @@ Both online and offline repair can use this strategy.
 | For this second effort, the ondisk parent pointer format as originally   |
 | proposed was ``(parent_inum, parent_gen, dirent_pos) → (dirent_name)``.  |
 | The format was changed during development to eliminate the requirement   |
-| of repair tools needing to to ensure that the ``dirent_pos`` field       |
+| of repair tools needing to ensure that the ``dirent_pos`` field       |
 | always matched when reconstructing a directory.                          |
 |                                                                          |
 | There were a few other ways to have solved that problem:                 |
-- 
2.43.0

