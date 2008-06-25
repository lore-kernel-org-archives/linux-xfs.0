Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 09:01:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5PG1L44017992
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 09:01:21 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 894C5D4CEEC
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 09:02:16 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id byNDvuI5VRG7nG6f for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 09:02:16 -0700 (PDT)
Date: Wed, 25 Jun 2008 18:02:22 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Performance problems with millions of inodes
Message-ID: <20080625180222.12885793@harpe.intellique.com>
In-Reply-To: <48625A46.1060206@uni-koblenz.de>
References: <4862598B.80905@uni-koblenz.de>
	<48625A46.1060206@uni-koblenz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Litauer <litauer@uni-koblenz.de>
Cc: xfs@oss.sgi.com

Le Wed, 25 Jun 2008 16:46:30 +0200
Christoph Litauer <litauer@uni-koblenz.de> écrivait:

> > 
> > Maybe the 143 million inodes cause this effect? Any idea how to
> > avoid it? 

Maybe you should try to add a "nobarrier" option at mount on the
slowest machine. Barriers can slow down operation tremendously...

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
