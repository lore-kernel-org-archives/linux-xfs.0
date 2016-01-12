Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA40C7F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:11:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36AFCAC001
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:11:06 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id BP3BNvRjt8qT39eW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:11:04 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id BD445209CA
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:11:03 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg4MC4Y8Lz5vMK
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:11:03 +0100 (CET)
Date: Tue, 12 Jan 2016 22:08:28 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 3/6] common/main.c: Replace nonstandard SIGCLD by SIGCHLD
Message-ID: <20160112210828.GD10044@nyan>
References: <cover.1452632647.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452632647.git.felix.janda@posteo.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 common/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/main.c b/common/main.c
index 3848499..faa66ee 100644
--- a/common/main.c
+++ b/common/main.c
@@ -2225,7 +2225,7 @@ static sig_printmap_t sig_printmap[ ] = {
 	{SIGTERM,	"SIGTERM"},
 	{SIGUSR1,	"SIGUSR1"},
 	{SIGUSR2,	"SIGUSR2"},
-	{SIGCLD,	"SIGCLD"},
+	{SIGCHLD,	"SIGCHLD"},
 	{SIGPWR,	"SIGPWR"},
 	{SIGURG,	"SIGURG"},
 	{SIGPOLL,	"SIGPOLL"},
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
