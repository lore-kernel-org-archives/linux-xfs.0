Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 04:28:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QBSidE007488
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:28:44 -0700
Received: from deliver.uni-koblenz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBFBF11D6412
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:29:44 -0700 (PDT)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15]) by cuda.sgi.com with ESMTP id PPNoq84TgG0UEbWH for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:29:44 -0700 (PDT)
Message-ID: <48637DA6.8040300@uni-koblenz.de>
Date: Thu, 26 Jun 2008 13:29:42 +0200
From: Christoph Litauer <litauer@uni-koblenz.de>
MIME-Version: 1.0
Subject: Re: Performance problems with millions of inodes
References: <4862598B.80905@uni-koblenz.de>	<48625A46.1060206@uni-koblenz.de> <20080625180222.12885793@harpe.intellique.com>
In-Reply-To: <20080625180222.12885793@harpe.intellique.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Emmanuel Florac schrieb:
> Le Wed, 25 Jun 2008 16:46:30 +0200
> Christoph Litauer <litauer@uni-koblenz.de> écrivait:
> 
>>> Maybe the 143 million inodes cause this effect? Any idea how to
>>> avoid it? 
> 
> Maybe you should try to add a "nobarrier" option at mount on the
> slowest machine. Barriers can slow down operation tremendously...
> 

Thanks for this hint. nobarrier improved file creation performance 
significantly (about 50 times).

-- 
Regards
Christoph
________________________________________________________________________
Christoph Litauer                  litauer@uni-koblenz.de
Uni Koblenz, Computing Center,     http://www.uni-koblenz.de/~litauer
Postfach 201602, 56016 Koblenz     Fon: +49 261 287-1311, Fax: -100 1311
PGP-Fingerprint: F39C E314 2650 650D 8092 9514 3A56 FBD8 79E3 27B2
