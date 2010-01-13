Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D4SUFb115864 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 22:28:30 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44A2C160C2F
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 20:29:24 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id YwtUiS2JKMrFlZwL for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 20:29:24 -0800 (PST)
Message-ID: <4B4D4C24.9060309@sandeen.net>
Date: Tue, 12 Jan 2010 22:29:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner
References: <1263350021-5733-1-git-send-email-david@fromorbit.com>
	<4B4D433C.7080501@sandeen.net>
In-Reply-To: <4B4D433C.7080501@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> Dave Chinner wrote:
>   
>> We don't need to see every compiler command line for every file that
>> is compiled. This makes it hard to see warnings and errors during
>> compile. For progress notification, we really only need to see the
>> diretory/file being operated on.
>>
>> Turn down the verbosity of output by suppressing various make output
>> and provide better overall visibility of which directory is being
>> operated on, what the operation is and what is being done to the
>> files by the build/clean process.
>>
>> Sample output from a build:
>>
>> ....
>> Building libxlog
>>     [CC] xfs_log_recover.c
>>     [CC] util.c
>>     [LD] libxlog.la
>>   
>>     
>
> ...
>
> swanky!
>
> What would you think of this on top of it, ripped straight from
> kbuild - that way "make V=1" works the same way as kbuild, but
> the default is still to be quiet.
>
> Also, just to show my kbuild bias, maybe consider outputting the target
> on the quiet line, instead of the source?  :)  But no biggie.
>
> -Eric
>
>   
ok now I'm being a make junkie, but a couple more things are "noisy"

Building include
    [LN] xfs
    [LN] disk
...
Building doc
   [ZIP] CHANGES.gz
Building po
[GETTXT] xfsprogs.pot

-Eric

diff --git a/include/Makefile b/include/Makefile
index d89480e..42e7233 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -43,7 +43,8 @@ LDIRT = xfs disk
 default install: xfs disk
 
 xfs disk:
-	$(LN_S) . $@
+	@echo "    [LN]" $@
+	$(Q)$(LN_S) . $@
 
 include $(BUILDRULES)
 diff --git a/doc/Makefile b/doc/Makefile
index 8f65b66..0a6de15 100644
--- a/doc/Makefile
+++ b/doc/Makefile
@@ -13,7 +13,8 @@ default: CHANGES.gz
 include $(BUILDRULES)
 
 CHANGES.gz:
-	$(ZIP) --best -c < CHANGES > $@
+	@echo "   [ZIP] $@"
+	$(Q)$(ZIP) --best -c < CHANGES > $@
 
 install: default

 	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)

diff --git a/include/buildrules b/include/buildrules
index 72edc69..ba004e6 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -61,7 +61,8 @@ endif
 
 ifdef POTHEAD
 $(POTHEAD): $(XGETTEXTFILES)
-	$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $(XGETTEXTFILES)
+	@echo "[GETTXT] $@"
+	$(Q)$(XGETTEXT) --language=C --keyword=_ --keyword=N_ -o $@ $(XGETTEXTFILES)
 
 # Update translations
 update-po: $(POTHEAD) $(wildcard $(TOPDIR)/po/*.po)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
