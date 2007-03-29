Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 08:33:08 -0700 (PDT)
Received: from smtp2.mundo-r.com (smtp3.mundo-r.com [212.51.32.191])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2TFWw6p030001
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 08:32:59 -0700
Message-ID: <460BDC1F.9030300@mundo-r.com>
Date: Thu, 29 Mar 2007 17:32:47 +0200
From: Antonio Trueba <atrueba@mundo-r.com>
MIME-Version: 1.0
Subject: New ATTR translations
Content-Type: multipart/mixed;
 boundary="------------090700090804050503040904"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090700090804050503040904
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello all,

Atached are new translations of attr to Spanish (es) and Galician (gl),
both complete against current CVS tree.

Regards,
--

--------------090700090804050503040904
Content-Type: text/x-gettext-translation;
 name="es.po"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="es.po"

# xfsprogs' ATTR package
# Copyright (C) 2007 Free Software Foundation
# This file is distributed under the same license as the xfsprogs package.
# Antonio Trueba <atrueba@users.sourceforge.net>, 2007
#
msgid ""
msgstr ""
"Project-Id-Version: attr-2.4.37.0\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2007-03-06 12:02+0100\n"
"PO-Revision-Date: 2007-03-16 23:29+0100\n"
"Last-Translator: Antonio Trueba <atrueba@users.sourceforge.net>\n"
"Language-Team: Spanish\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=utf-8\n"
"Content-Transfer-Encoding: 8bit\n"
"X-Poedit-Language: Spanish\n"

#: ../attr/attr.c:46
#, c-format
msgid ""
"Usage: %s [-LRSq] -s attrname [-V attrvalue] pathname  # set value\n"
"       %s [-LRSq] -g attrname pathname                 # get value\n"
"       %s [-LRSq] -r attrname pathname                 # remove attr\n"
"       %s [-LRq]  -l pathname                          # list attrs \n"
"      -s reads a value from stdin and -g writes a value to stdout\n"
msgstr ""
"Uso: %s [-LRSq] -s nomatrib ruta [-V valoratr] ruta  # establecer valor\n"
"     %s [-LRSq] -g nomatrib ruta                     # obtener valor\n"
"     %s [-LRSq] -r nomatrib ruta                     # borrar atributo\n"
"     %s [-LRq]  -l ruta                              # listar atributos \n"
"    -s lee un valor de la entrada estándar y -g escribe un valor a la salida estándar\n"

#: ../attr/attr.c:83
#: ../attr/attr.c:100
#: ../attr/attr.c:109
#: ../attr/attr.c:118
#, c-format
msgid "Only one of -s, -g, -r, or -l allowed\n"
msgstr "Sólo está permitido usar uno de -s, -g, -r, o -l\n"

#: ../attr/attr.c:91
#, c-format
msgid "-V only allowed with -s\n"
msgstr "-V sólo está permitido con -s\n"

#: ../attr/attr.c:136
#, c-format
msgid "Unrecognized option: %c\n"
msgstr "Opción no reconocida: %c\n"

#: ../attr/attr.c:143
#, c-format
msgid "A filename to operate on is required\n"
msgstr "Se necesita un nombre de archivo sobre el que operar\n"

#: ../attr/attr.c:171
#, c-format
msgid "Could not set \"%s\" for %s\n"
msgstr "No se pudo establecer \"%s\" para %s\n"

#: ../attr/attr.c:176
#, c-format
msgid "Attribute \"%s\" set to a %d byte value for %s:\n"
msgstr "Atributo \"%s\" establecido al valor byte %d para %s:\n"

#: ../attr/attr.c:194
#, c-format
msgid "Could not get \"%s\" for %s\n"
msgstr "No se pudo obtener \"%s\" para %s\n"

#: ../attr/attr.c:199
#, c-format
msgid "Attribute \"%s\" had a %d byte value for %s:\n"
msgstr "El atributo \"%s\" tenía el valor byte %d para %s:\n"

#: ../attr/attr.c:212
#, c-format
msgid "Could not remove \"%s\" for %s\n"
msgstr "No se pudo eliminar \"%s\" para %s\n"

#: ../attr/attr.c:230
#, c-format
msgid "Could not list \"%s\" for %s\n"
msgstr "No se pudo listar \"%s\" para %s\n"

#: ../attr/attr.c:240
#, c-format
msgid "Attribute \"%s\" has a %d byte value for %s\n"
msgstr "El atributo \"%s\" tiene el valor byte %d para %s\n"

#: ../attr/attr.c:252
#, c-format
msgid "At least one of -s, -g, -r, or -l is required\n"
msgstr "Se necesita al menos uno de -s, -g, -r, o -l\n"

#: ../getfattr/getfattr.c:98
#: ../setfattr/setfattr.c:70
msgid "No such attribute"
msgstr "Atributo inexistente"

#: ../getfattr/getfattr.c:256
#, c-format
msgid "%s: Removing leading '/' from absolute path names\n"
msgstr "%s: Eliminando '/' inicial en nombres de ruta absolutos\n"

#: ../getfattr/getfattr.c:394
#, c-format
msgid "%s %s -- get extended attributes\n"
msgstr "%s %s -- obtener atributos extendidos\n"

#: ../getfattr/getfattr.c:396
#: ../setfattr/setfattr.c:175
#, c-format
msgid "Usage: %s %s\n"
msgstr "Uso: %s %s\n"

#: ../getfattr/getfattr.c:399
#, c-format
msgid ""
"  -n, --name=name         get the named extended attribute value\n"
"  -d, --dump              get all extended attribute values\n"
"  -e, --encoding=...      encode values (as 'text', 'hex' or 'base64')\n"
"      --match=pattern     only get attributes with names matching pattern\n"
"      --only-values       print the bare values only\n"
"  -h, --no-dereference    do not dereference symbolic links\n"
"      --absolute-names    don't strip leading '/' in pathnames\n"
"  -R, --recursive         recurse into subdirectories\n"
"  -L, --logical           logical walk, follow symbolic links\n"
"  -P  --physical          physical walk, do not follow symbolic links\n"
"      --version           print version and exit\n"
"      --help              this help text\n"
msgstr ""
"  -n, --name=nombre       obtener el atributo extendido \"nombre\"\n"
"  -d, --dump              obtener valor de todos los atributos extendidos\n"
"  -e, --encoding=...      codificar valores (como 'text', 'hex' o 'base64')\n"
"      --match=patrón      sólo obtener atributos cuyo nombre coincida con \"patrón\"\n"
"      --only-values       sólo mostrar los valores en crudo\n"
"  -h, --no-dereference    no resolver enlaces simbólicos\n"
"      --absolute-names    no eliminar '/' iniciales en nombres de ruta\n"
"  -R, --recursive         recorrer subdirectorios recursivamente\n"
"  -L, --logical           recorrido lógico, siguiendo enlaces simbólicos\n"
"  -P  --physical          recorrido físico, no seguir enlaces simbólicos\n"
"      --version           mostrar versión y salir\n"
"      --help              este texto de ayuda\n"

#: ../getfattr/getfattr.c:496
#, c-format
msgid "%s: invalid regular expression \"%s\"\n"
msgstr "%s: expresión regular inválida \"%s\"\n"

#: ../getfattr/getfattr.c:514
#, c-format
msgid ""
"Usage: %s %s\n"
"Try `%s --help' for more information.\n"
msgstr ""
"Uso: %s %s\n"
"Escriba `%s --help' para más información.\n"

#: ../setfattr/setfattr.c:123
#, c-format
msgid "%s: %s: No filename found in line %d, aborting\n"
msgstr "%s: %s: No se encontró nombre de archivo en línea %d, abortando\n"

#: ../setfattr/setfattr.c:127
#, c-format
msgid "%s: No filename found in line %d of standard input, aborting\n"
msgstr "%s: %s: No se encontró nombre de archivo en línea %d de entrada estándar, abortando\n"

#: ../setfattr/setfattr.c:174
#, c-format
msgid "%s %s -- set extended attributes\n"
msgstr "%s %s -- establecer atributos extendidos\n"

#: ../setfattr/setfattr.c:176
#, c-format
msgid "       %s %s\n"
msgstr "       %s %s\n"

#: ../setfattr/setfattr.c:178
#, c-format
msgid ""
"  -n, --name=name         set the value of the named extended attribute\n"
"  -x, --remove=name       remove the named extended attribute\n"
"  -v, --value=value       use value as the attribute value\n"
"  -h, --no-dereference    do not dereference symbolic links\n"
"      --restore=file      restore extended attributes\n"
"      --version           print version and exit\n"
"      --help              this help text\n"
msgstr ""
"  -n, --name=nombre       establecer valor para el atributo extendido \"nombre\"\n"
"  -x, --remove=nombre     eliminar atributo extendido \"nombre\"\n"
"  -v, --value=valor       usar \"valor\" como el valor del atributo\n"
"  -h, --no-dereference    no resolver enlaces simbólicos\n"
"      --restore=archivo   restaurar atributos extendidos\n"
"      --version           mostrar versión y salir\n"
"      --help              este texto de ayuda\n"

#: ../setfattr/setfattr.c:253
#, c-format
msgid ""
"Usage: %s %s\n"
"       %s %s\n"
"Try `%s --help' for more information.\n"
msgstr ""
"Uso: %s %s\n"
"       %s %s\n"
"Escriba `%s --help' para más información.\n"

#: ../libattr/attr_copy_fd.c:82
#: ../libattr/attr_copy_fd.c:97
#: ../libattr/attr_copy_file.c:80
#: ../libattr/attr_copy_file.c:95
#, c-format
msgid "listing attributes of %s"
msgstr "listando atributos de %s"

#: ../libattr/attr_copy_fd.c:117
#: ../libattr/attr_copy_fd.c:134
#: ../libattr/attr_copy_file.c:115
#: ../libattr/attr_copy_file.c:132
#, c-format
msgid "getting attribute %s of %s"
msgstr "obteniendo atributo %s de %s"

#: ../libattr/attr_copy_fd.c:147
#: ../libattr/attr_copy_fd.c:165
#: ../libattr/attr_copy_file.c:144
#: ../libattr/attr_copy_file.c:163
#, c-format
msgid "setting attributes for %s"
msgstr "estableciendo atributos para %s"

#: ../libattr/attr_copy_fd.c:153
#: ../libattr/attr_copy_file.c:151
#, c-format
msgid "setting attribute %s for %s"
msgstr "estableciendo atributo %s para %s"


--------------090700090804050503040904
Content-Type: text/x-gettext-translation;
 name="gl.po"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="gl.po"

# xfsprogs' ATTR package
# Copyright (C) 2007 Free Software Foundation
# This file is distributed under the same license as the xfsprogs package.
# Antonio Trueba <atrueba@users.sourceforge.net>, 2007
#
msgid ""
msgstr ""
"Project-Id-Version: attr-2.4.37\n"
"Report-Msgid-Bugs-To: \n"
"POT-Creation-Date: 2007-03-06 12:02+0100\n"
"PO-Revision-Date: 2007-03-16 23:28+0100\n"
"Last-Translator: Antonio Trueba <atrueba@users.sourceforge.net>\n"
"Language-Team: Galician\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=utf-8\n"
"Content-Transfer-Encoding: 8bit\n"
"X-Poedit-Language: Galician\n"

#: ../attr/attr.c:46
#, c-format
msgid ""
"Usage: %s [-LRSq] -s attrname [-V attrvalue] pathname  # set value\n"
"       %s [-LRSq] -g attrname pathname                 # get value\n"
"       %s [-LRSq] -r attrname pathname                 # remove attr\n"
"       %s [-LRq]  -l pathname                          # list attrs \n"
"      -s reads a value from stdin and -g writes a value to stdout\n"
msgstr ""
"Uso:   %s [-LRSq] -s nomatrib rota [-V valatrib] rota  # establecer valor\n"
"       %s [-LRSq] -g nomatrib rota                     # obter valor\n"
"       %s [-LRSq] -r nomatrib rota                     # borrar atributo\n"
"       %s [-LRq]  -l rota                              # listar atributos \n"
"      -s le un valor da entrada estándar e -g escrebe un valor á saída estándar\n"

#: ../attr/attr.c:83
#: ../attr/attr.c:100
#: ../attr/attr.c:109
#: ../attr/attr.c:118
#, c-format
msgid "Only one of -s, -g, -r, or -l allowed\n"
msgstr "Só se permite un de -s, -g, -r, ou -l\n"

#: ../attr/attr.c:91
#, c-format
msgid "-V only allowed with -s\n"
msgstr "-V só está permitido con -s\n"

#: ../attr/attr.c:136
#, c-format
msgid "Unrecognized option: %c\n"
msgstr "Opción non recoñecida: %c\n"

#: ../attr/attr.c:143
#, c-format
msgid "A filename to operate on is required\n"
msgstr "Precísase un nome de ficheiro a tratar\n"

#: ../attr/attr.c:171
#, c-format
msgid "Could not set \"%s\" for %s\n"
msgstr "Non se puido establecer \"%s\" para %s\n"

#: ../attr/attr.c:176
#, c-format
msgid "Attribute \"%s\" set to a %d byte value for %s:\n"
msgstr "Atributo \"%s\" establecido ó valor byte %d para %s:\n"

#: ../attr/attr.c:194
#, c-format
msgid "Could not get \"%s\" for %s\n"
msgstr "Non se puido obter \"%s\" para %s\n"

#: ../attr/attr.c:199
#, c-format
msgid "Attribute \"%s\" had a %d byte value for %s:\n"
msgstr "O atributo \"%s\" tiña o valor byte %d para %s:\n"

#: ../attr/attr.c:212
#, c-format
msgid "Could not remove \"%s\" for %s\n"
msgstr "Non se puido eliminar \"%s\" para %s\n"

#: ../attr/attr.c:230
#, c-format
msgid "Could not list \"%s\" for %s\n"
msgstr "Non se puido listar \"%s\" para %s\n"

#: ../attr/attr.c:240
#, c-format
msgid "Attribute \"%s\" has a %d byte value for %s\n"
msgstr "O atributo \"%s\" ten o valor byte %d para %s\n"

#: ../attr/attr.c:252
#, c-format
msgid "At least one of -s, -g, -r, or -l is required\n"
msgstr "É preciso alomenos un de -s, -g, -r, ou -l\n"

#: ../getfattr/getfattr.c:98
#: ../setfattr/setfattr.c:70
msgid "No such attribute"
msgstr "Non hai tal atributo"

#: ../getfattr/getfattr.c:256
#, c-format
msgid "%s: Removing leading '/' from absolute path names\n"
msgstr "%s: Borrando '/' iniciais dos nomes de rota absolutos\n"

#: ../getfattr/getfattr.c:394
#, c-format
msgid "%s %s -- get extended attributes\n"
msgstr "%s %s -- obter atributos estendidos\n"

#: ../getfattr/getfattr.c:396
#: ../setfattr/setfattr.c:175
#, c-format
msgid "Usage: %s %s\n"
msgstr "Uso: %s %s\n"

#: ../getfattr/getfattr.c:399
#, c-format
msgid ""
"  -n, --name=name         get the named extended attribute value\n"
"  -d, --dump              get all extended attribute values\n"
"  -e, --encoding=...      encode values (as 'text', 'hex' or 'base64')\n"
"      --match=pattern     only get attributes with names matching pattern\n"
"      --only-values       print the bare values only\n"
"  -h, --no-dereference    do not dereference symbolic links\n"
"      --absolute-names    don't strip leading '/' in pathnames\n"
"  -R, --recursive         recurse into subdirectories\n"
"  -L, --logical           logical walk, follow symbolic links\n"
"  -P  --physical          physical walk, do not follow symbolic links\n"
"      --version           print version and exit\n"
"      --help              this help text\n"
msgstr ""
"  -n, --name=nome         obter o valor de atributo estendido especificado\n"
"  -d, --dump              obté-lo valor de tódolos atributos estendidos\n"
"  -e, --encoding=...      codificar valores (coma 'text', 'hex' ou 'base64')\n"
"      --match=patrón      só obté-los atributos de nome coincidente co patrón\n"
"      --only-values       só amosá-los valores crus dos atributos\n"
"  -h, --no-dereference    non resolvé-los enlaces simbólicos\n"
"      --absolute-names    non eliminá-los '/' iniciáis en nomes de rota\n"
"  -R, --recursive         recorrer subdirectorios recursivamente\n"
"  -L, --logical           percorrido lóxico, seguindo enlaces simbólicos\n"
"  -P  --physical          percorrido físico, non segui-los enlaces simbólicos\n"
"      --version           amosar versión e sair\n"
"      --help              este texto de axuda\n"

#: ../getfattr/getfattr.c:496
#, c-format
msgid "%s: invalid regular expression \"%s\"\n"
msgstr "%s: expresión regular incorrecta: \"%s\"\n"

#: ../getfattr/getfattr.c:514
#, c-format
msgid ""
"Usage: %s %s\n"
"Try `%s --help' for more information.\n"
msgstr ""
"Uso: %s %s\n"
"Escriba `%s --help' para obter máis información.\n"

#: ../setfattr/setfattr.c:123
#, c-format
msgid "%s: %s: No filename found in line %d, aborting\n"
msgstr "%s: %s: Non se atopuo un nome de ficheiro na liña %d, abortando\n"

#: ../setfattr/setfattr.c:127
#, c-format
msgid "%s: No filename found in line %d of standard input, aborting\n"
msgstr "%s: Non se atopou un nome de ficheiro na liña %d da entrada estándar, abortando\n"

#: ../setfattr/setfattr.c:174
#, c-format
msgid "%s %s -- set extended attributes\n"
msgstr "%s %s -- establecer atributos estendidos\n"

#: ../setfattr/setfattr.c:176
#, c-format
msgid "       %s %s\n"
msgstr "       %s %s\n"

#: ../setfattr/setfattr.c:178
#, c-format
msgid ""
"  -n, --name=name         set the value of the named extended attribute\n"
"  -x, --remove=name       remove the named extended attribute\n"
"  -v, --value=value       use value as the attribute value\n"
"  -h, --no-dereference    do not dereference symbolic links\n"
"      --restore=file      restore extended attributes\n"
"      --version           print version and exit\n"
"      --help              this help text\n"
msgstr ""
"  -n, --name=nome         establecé-lo valor do atributo estendido especificado\n"
"  -x, --remove=nome       eliminá-lo atributo estendido especificado\n"
"  -v, --value=valor       usar 'valor' coma o valor do atributo\n"
"  -h, --no-dereference    non resolver enlaces simbólicos\n"
"      --restore=fich      restaurar atributos estendidos\n"
"      --version           amosar versión e sair\n"
"      --help              este texto de axuda\n"

#: ../setfattr/setfattr.c:253
#, c-format
msgid ""
"Usage: %s %s\n"
"       %s %s\n"
"Try `%s --help' for more information.\n"
msgstr ""
"Uso: %s %s\n"
"       %s %s\n"
"Escriba `%s --help' para obter máis información.\n"

#: ../libattr/attr_copy_fd.c:82
#: ../libattr/attr_copy_fd.c:97
#: ../libattr/attr_copy_file.c:80
#: ../libattr/attr_copy_file.c:95
#, c-format
msgid "listing attributes of %s"
msgstr "listando atributos de %s"

#: ../libattr/attr_copy_fd.c:117
#: ../libattr/attr_copy_fd.c:134
#: ../libattr/attr_copy_file.c:115
#: ../libattr/attr_copy_file.c:132
#, c-format
msgid "getting attribute %s of %s"
msgstr "obtendo atributo %s de %s"

#: ../libattr/attr_copy_fd.c:147
#: ../libattr/attr_copy_fd.c:165
#: ../libattr/attr_copy_file.c:144
#: ../libattr/attr_copy_file.c:163
#, c-format
msgid "setting attributes for %s"
msgstr "establecendo atributos para %s"

#: ../libattr/attr_copy_fd.c:153
#: ../libattr/attr_copy_file.c:151
#, c-format
msgid "setting attribute %s for %s"
msgstr "establecendo atributo %s para %s"


--------------090700090804050503040904--
