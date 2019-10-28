Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1052CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 21:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AB7221479
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 21:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfJ1VXE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 17:23:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:10634 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729836AbfJ1VXE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Oct 2019 17:23:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 14:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,241,1569308400"; 
   d="gz'50?scan'50,208,50";a="193391703"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 28 Oct 2019 14:23:01 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iPCTc-0007bX-Ip; Tue, 29 Oct 2019 05:23:00 +0800
Date:   Tue, 29 Oct 2019 05:22:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     kbuild-all@lists.01.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [xfs-linux:xfs-5.5-merge 70/72] fs/compat_ioctl.c:1084:25: error:
 'cmd' undeclared here (not in a function); did you mean 'cma'?
Message-ID: <201910290545.EnIGT2Co%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5azqhammkfj6qug2"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--5azqhammkfj6qug2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-5.5-merge
head:   da1faf13deb0109fb40ad2f4e93e680b34898b18
commit: d5e20bfa0b77b44cff86afe65fda85e3eb6b3582 [70/72] fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers
config: s390-debug_defconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout d5e20bfa0b77b44cff86afe65fda85e3eb6b3582
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/compat_ioctl.c: In function '__do_compat_sys_ioctl':
   fs/compat_ioctl.c:1056:2: error: case label not within a switch statement
     case FICLONE:
     ^~~~
   fs/compat_ioctl.c:1057:2: error: case label not within a switch statement
     case FICLONERANGE:
     ^~~~
   fs/compat_ioctl.c:1058:2: error: case label not within a switch statement
     case FIDEDUPERANGE:
     ^~~~
   fs/compat_ioctl.c:1059:2: error: case label not within a switch statement
     case FS_IOC_FIEMAP:
     ^~~~
   fs/compat_ioctl.c:1062:2: error: case label not within a switch statement
     case FIBMAP:
     ^~~~
   fs/compat_ioctl.c:1063:2: error: case label not within a switch statement
     case FIGETBSZ:
     ^~~~
   fs/compat_ioctl.c:1064:2: error: case label not within a switch statement
     case FIONREAD:
     ^~~~
   fs/compat_ioctl.c:1066:4: error: break statement not within loop or switch
       break;
       ^~~~~
   fs/compat_ioctl.c:1069:2: error: 'default' label not within a switch statement
     default:
     ^~~~~~~
   fs/compat_ioctl.c:1078:3: error: break statement not within loop or switch
      break;
      ^~~~~
   fs/compat_ioctl.c:1077:4: error: label 'do_ioctl' used but not defined
       goto do_ioctl;
       ^~~~
   fs/compat_ioctl.c:1073:5: error: label 'out_fput' used but not defined
        goto out_fput;
        ^~~~
   fs/compat_ioctl.c:1005:3: error: label 'out' used but not defined
      goto out;
      ^~~~
   fs/compat_ioctl.c:1079:2: warning: no return statement in function returning non-void [-Wreturn-type]
     }
     ^
   fs/compat_ioctl.c: At top level:
   fs/compat_ioctl.c:1081:2: error: expected identifier or '(' before 'if'
     if (compat_ioctl_check_table(XFORM(cmd)))
     ^~
   fs/compat_ioctl.c:1084:2: warning: data definition has no type or storage class
     error = do_ioctl_trans(cmd, arg, f.file);
     ^~~~~
   fs/compat_ioctl.c:1084:2: error: type defaults to 'int' in declaration of 'error' [-Werror=implicit-int]
>> fs/compat_ioctl.c:1084:25: error: 'cmd' undeclared here (not in a function); did you mean 'cma'?
     error = do_ioctl_trans(cmd, arg, f.file);
                            ^~~
                            cma
   fs/compat_ioctl.c:1084:30: error: 'arg' undeclared here (not in a function)
     error = do_ioctl_trans(cmd, arg, f.file);
                                 ^~~
   fs/compat_ioctl.c:1084:35: error: 'f' undeclared here (not in a function); did you mean 'fd'?
     error = do_ioctl_trans(cmd, arg, f.file);
                                      ^
                                      fd
   fs/compat_ioctl.c:1085:2: error: expected identifier or '(' before 'if'
     if (error == -ENOIOCTLCMD)
     ^~
   fs/compat_ioctl.c:1088:2: error: expected identifier or '(' before 'goto'
     goto out_fput;
     ^~~~
   fs/compat_ioctl.c:1090:15: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
     found_handler:
                  ^
   fs/compat_ioctl.c:1092:10: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
     do_ioctl:
             ^
   fs/compat_ioctl.c:1094:10: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
     out_fput:
             ^
   fs/compat_ioctl.c:1096:5: error: expected '=', ',', ';', 'asm' or '__attribute__' before ':' token
     out:
        ^
   fs/compat_ioctl.c:1098:1: error: expected identifier or '(' before '}' token
    }
    ^
   fs/compat_ioctl.c:976:12: warning: 'compat_ioctl_check_table' defined but not used [-Wunused-function]
    static int compat_ioctl_check_table(unsigned int xcmd)
               ^~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +1084 fs/compat_ioctl.c

3e63cbb1efca7d Ankit Jain        2009-06-19  1055  
d79bdd52d8be70 Darrick J. Wong   2015-12-19  1056  	case FICLONE:
d79bdd52d8be70 Darrick J. Wong   2015-12-19  1057  	case FICLONERANGE:
54dbc151723756 Darrick J. Wong   2015-12-19  1058  	case FIDEDUPERANGE:
ceac204e1da942 Josef Bacik       2017-09-29  1059  	case FS_IOC_FIEMAP:
d79bdd52d8be70 Darrick J. Wong   2015-12-19  1060  		goto do_ioctl;
d79bdd52d8be70 Darrick J. Wong   2015-12-19  1061  
6272e2667965df Christoph Hellwig 2007-05-08  1062  	case FIBMAP:
6272e2667965df Christoph Hellwig 2007-05-08  1063  	case FIGETBSZ:
6272e2667965df Christoph Hellwig 2007-05-08  1064  	case FIONREAD:
496ad9aa8ef448 Al Viro           2013-01-23  1065  		if (S_ISREG(file_inode(f.file)->i_mode))
6272e2667965df Christoph Hellwig 2007-05-08  1066  			break;
6272e2667965df Christoph Hellwig 2007-05-08  1067  		/*FALL THROUGH*/
6272e2667965df Christoph Hellwig 2007-05-08  1068  
6272e2667965df Christoph Hellwig 2007-05-08  1069  	default:
72c2d531920048 Al Viro           2013-09-22  1070  		if (f.file->f_op->compat_ioctl) {
2903ff019b346a Al Viro           2012-08-28  1071  			error = f.file->f_op->compat_ioctl(f.file, cmd, arg);
6272e2667965df Christoph Hellwig 2007-05-08  1072  			if (error != -ENOIOCTLCMD)
6272e2667965df Christoph Hellwig 2007-05-08  1073  				goto out_fput;
6272e2667965df Christoph Hellwig 2007-05-08  1074  		}
6272e2667965df Christoph Hellwig 2007-05-08  1075  
72c2d531920048 Al Viro           2013-09-22  1076  		if (!f.file->f_op->unlocked_ioctl)
6272e2667965df Christoph Hellwig 2007-05-08  1077  			goto do_ioctl;
6272e2667965df Christoph Hellwig 2007-05-08  1078  		break;
6272e2667965df Christoph Hellwig 2007-05-08  1079  	}
6272e2667965df Christoph Hellwig 2007-05-08  1080  
661f627da98c06 Arnd Bergmann     2009-11-05 @1081  	if (compat_ioctl_check_table(XFORM(cmd)))
6272e2667965df Christoph Hellwig 2007-05-08  1082  		goto found_handler;
6272e2667965df Christoph Hellwig 2007-05-08  1083  
66cf191f3eae45 Al Viro           2016-01-07 @1084  	error = do_ioctl_trans(cmd, arg, f.file);
07d106d0a33d60 Linus Torvalds    2012-01-05  1085  	if (error == -ENOIOCTLCMD)
07d106d0a33d60 Linus Torvalds    2012-01-05  1086  		error = -ENOTTY;
6272e2667965df Christoph Hellwig 2007-05-08  1087  
6272e2667965df Christoph Hellwig 2007-05-08  1088  	goto out_fput;
6272e2667965df Christoph Hellwig 2007-05-08  1089  
6272e2667965df Christoph Hellwig 2007-05-08  1090   found_handler:
789f0f89118a80 Arnd Bergmann     2009-11-05  1091  	arg = (unsigned long)compat_ptr(arg);
6272e2667965df Christoph Hellwig 2007-05-08  1092   do_ioctl:
2903ff019b346a Al Viro           2012-08-28  1093  	error = do_vfs_ioctl(f.file, fd, cmd, arg);
6272e2667965df Christoph Hellwig 2007-05-08  1094   out_fput:
2903ff019b346a Al Viro           2012-08-28  1095  	fdput(f);
6272e2667965df Christoph Hellwig 2007-05-08  1096   out:
6272e2667965df Christoph Hellwig 2007-05-08  1097  	return error;
6272e2667965df Christoph Hellwig 2007-05-08  1098  }
6272e2667965df Christoph Hellwig 2007-05-08  1099  

:::::: The code at line 1084 was first introduced by commit
:::::: 66cf191f3eae4582a83cb4251b75b43bee95a999 compat_ioctl: don't pass fd around when not needed

:::::: TO: Al Viro <viro@zeniv.linux.org.uk>
:::::: CC: Al Viro <viro@zeniv.linux.org.uk>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--5azqhammkfj6qug2
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--5azqhammkfj6qug2--
